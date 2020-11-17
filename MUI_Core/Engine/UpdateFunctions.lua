-- luacheck: ignore MayronUI LibStub self 143 631
local tk, _, _, _, obj = _G.MayronUI:GetCoreComponents();
local table, ipairs, string, unpack = _G.table, _G.ipairs, _G.string, _G.unpack;
local tostring, pairs = _G.tostring, _G.pairs;

---@type LibMayronDB
local libMayronDB = LibStub:GetLibrary("LibMayronDB");

---@type Engine
local Engine = obj:Import("MayronUI.Engine");

---@type BaseModule
local BaseModule = Engine:Get("BaseModule");

local function ExecuteUpdateFunction(path, updateFunction, setting, executed, onPre, onPost)
  if (obj:IsTable(executed) and executed[path]) then
    return;
  end

  local keysList = tk.Tables:ConvertPathToKeysList(path);

  if (obj:IsFunction(onPre)) then
    local onPreResults = obj:PopTable(onPre(setting, keysList));

    if (#onPreResults > 0) then
      if (obj:IsFunction(onPost)) then
        onPost(setting, keysList, updateFunction(setting, keysList, unpack(onPreResults)));
      else
        updateFunction(setting, keysList, unpack(onPreResults));
      end
    end

    obj:PushTable(onPreResults);
  else
    if (obj:IsFunction(onPost)) then
      onPost(setting, keysList, updateFunction(setting, keysList));
    else
      updateFunction(setting, keysList);
    end
  end

  if (obj:IsTable(executed)) then
    -- if executing all settings then this is used
    executed[path] = true;
  end
end

local function HasMatchingPathPattern(path, patterns)
  for _, pattern in ipairs(patterns) do
    if (path:find(pattern)) then
      return true;

    elseif (pattern:find("%(.*|.*%)")) then
      local optionalKeys = pattern:match("(%(.*|.*%)).*");

      for key in string.gmatch(optionalKeys, "([^(|)]+)") do
        local concretePath = pattern:gsub("%(.*|.*%)", key);

        if (not obj:IsStringNilOrWhiteSpace(concretePath) and path:match(concretePath)) then
          return true;
        end
      end
    end
  end

  return false;
end

local function FindMatchingGroupValue(path, options)
  if (not (options and options.groups)) then
    return;
  end

  path = path:gsub("%[", ".");
  path = path:gsub("%]", "");

  for _, groupOptions in pairs(options.groups) do

    if (HasMatchingPathPattern(path, groupOptions.patterns)) then

      if (groupOptions.value) then
        local updateFunction = groupOptions.value;

        if (obj:IsTable(updateFunction)) then
          for _, key in obj:IterateArgs(string.split(".", path)) do

            if (updateFunction[key]) then
              updateFunction = updateFunction[key];

              if (obj:IsFunction(updateFunction)) then
                break;
              end
            end
          end
        end

        return updateFunction, groupOptions.onPre, groupOptions.onPost;
      end
    end
  end
end

do
  local ignoreEnabledOption = { onExecuteAll = {ignore = { "^enabled$" } } };

  Engine:DefineParams("Observer", "table", "?table");
  ---Executed when a profile is loaded and the UI needs to apply changes (this includes loading the initial profile on start up)
  ---@param observer Observer The database observer node to attach the update functions to
  ---@param updateFunctions table A table containing update functions mapped to settings
  ---@param options table|nil An optional table containing options to control how update
  function BaseModule:RegisterUpdateFunctions(data, observer, updateFunctions, options)
    if (not data.settings) then
      data.settings = observer:GetUntrackedTable(); -- disconnected from database
    end

    if (obj:IsTable(options)) then
      if (not data.options) then
        data.options = options;

      elseif (obj:IsTable(data.options)) then
        tk.Tables:Fill(data.options, options);
      end
    end

    if (not data.updateFunctions) then
      data.updateFunctions = updateFunctions;
    else
      -- append new update functions
      tk.Tables:Fill(data.updateFunctions, updateFunctions);
    end

    if (not data.updateFunctions.enabled and data.settings.enabled ~= nil) then
      data.updateFunctions.enabled = function(value)
        self:SetEnabled(value);
      end
    end

    if (data.options) then
      if (data.options.onExecuteAll and data.options.onExecuteAll.ignore) then
        if (not tk.Tables:Contains(data.options.onExecuteAll.ignore, "^enabled$")) then
          table.insert(data.options.onExecuteAll.ignore, "^enabled$");
        end
      elseif (data.options.onExecuteAll) then
        data.options.onExecuteAll.ignore = ignoreEnabledOption.onExecuteAll.ignore;
      else
        data.options.onExecuteAll = ignoreEnabledOption.onExecuteAll;
      end
    else
      data.options = ignoreEnabledOption;
    end

    local observerPath = observer:GetPathAddress();
    local dbObject = MayronUI:GetModuleComponent(self:GetModuleKey(), "Database");

    if (not dbObject) then
      dbObject = MayronUI:GetCoreComponent("Database");
    end

    -- updateFunctionPath is the located function (or table if no function found) path
    -- originalPathOfValue is the original path LibMayronDB tried to find

    dbObject:RegisterUpdateFunctions(observerPath, data.updateFunctions, function(updateFunction, fullPath, newValue)
      local onPre, onPost;
      local settingPath = fullPath:gsub(observerPath..".", tk.Strings.Empty);

      if (updateFunction == nil) then
        -- check if a group function can be used
        updateFunction, onPre, onPost = FindMatchingGroupValue(settingPath, data.options);
      end

      if (obj:IsFunction(updateFunction)) then
        -- update settings:
        dbObject:SetPathValue(data.settings, settingPath, newValue);

        if (self:IsEnabled() or updateFunction == data.updateFunctions.enabled) then
          ExecuteUpdateFunction(settingPath, updateFunction, newValue, nil, onPre, onPost);
        end
      else
        -- update settings:
        dbObject:SetPathValue(data.settings, settingPath, newValue);
      end
    end);
  end
end

do
  local MAX_BLOCKS = 20;

  local function GetBlocked(options, path, executed)
    if (options.onExecuteAll.dependencies) then
      for dependencyValue, dependency in pairs(options.onExecuteAll.dependencies) do
        if (path ~= dependency and path:match(dependencyValue) and not executed[dependency]) then
          return true;
        end
      end
    end

    return false;
  end

  local function GetIgnored(options, path, executedTable)
    if (executedTable[path]) then
      return true; -- been executed before
    end

    if (not options) then
      return false;
    end

    if (options.onExecuteAll.first and options.onExecuteAll.first[path]) then
      return true;
    end

    if (options.onExecuteAll.last and options.onExecuteAll.last[path]) then
      return true;
    end

    for _, ignoreValue in ipairs(options.onExecuteAll.ignore) do
      if (path:match(ignoreValue)) then
        return true;
      end
    end

    return false;
  end

  --"first", data.options, data.updateFunctions, data.settings, executedTable
  local function ExecuteOrdered(orderKey, options, updateFunction, setting, executed)
    if (not options.onExecuteAll[orderKey]) then
      return false;
    end

    for _, path in ipairs(options.onExecuteAll[orderKey]) do
      -- both param.updateFunction and param.setitng will be tables
      local currentUpdateFunction = libMayronDB:ParsePathValue(updateFunction, path);
      local currentSetting = libMayronDB:ParsePathValue(setting, path);
      local onPre, onPost;

      if (currentUpdateFunction == nil) then
        -- check if a group function can be used
        currentUpdateFunction, onPre, onPost = FindMatchingGroupValue(path, options);
      end

      obj:Assert(obj:IsFunction(currentUpdateFunction), "No update function exists for ordered path '%s'", path);
        ExecuteUpdateFunction(path, currentUpdateFunction, currentSetting, executed, onPre, onPost);
    end
  end

  local function ExecuteAllUpdateFunctions(options, updateFunctionsTable, settingsTable, executedTable, blockedTable, previousPath)
    for key, setting in pairs(settingsTable) do
      local path = tostring(key);
      local updateFunction = updateFunctionsTable;
      local onPre, onPost;

      if (previousPath) then
        path = string.format("%s.%s", previousPath, key);
      end

      local ignored = GetIgnored(options, path, executedTable);

      if (not ignored) then
        -- find next update function:
        if (not obj:IsFunction(updateFunction)) then

          if (obj:IsTable(updateFunction)) then
            -- get next function value
            updateFunction = updateFunction[key];
          end

          if (updateFunction == nil) then
            -- check if a group function can be used
            updateFunction, onPre, onPost = FindMatchingGroupValue(path, options);
          end
        end

        local blocked = GetBlocked(options, path, executedTable);

        if (blocked) then
          blockedTable[path] = obj:PopTable(path, updateFunction, setting, executedTable, onPre, onPost);

        elseif (obj:IsFunction(updateFunction)) then -- CanCallUpdateFunction(options, path, updateFunction, setting)
          ExecuteUpdateFunction(path, updateFunction, setting, executedTable, onPre, onPost);

        elseif (obj:IsTable(setting)) then
          ExecuteAllUpdateFunctions(options, updateFunction, setting, executedTable, blockedTable, path);
        end
      end
    end
  end

  function BaseModule:ExecuteAllUpdateFunctions(data)
    if (not obj:IsTable(data.updateFunctions)) then return; end

    data.executingAllUpdateFunctions = true;

    local executedTable = obj:PopTable();
    local blockedTable = obj:PopTable();

    ExecuteOrdered("first", data.options, data.updateFunctions, data.settings, executedTable);
    ExecuteAllUpdateFunctions(data.options, data.updateFunctions, data.settings, executedTable, blockedTable);

    local blockedValues = false;
    local totalRepeats = 0;

    repeat
      for path, blockedValue in pairs(blockedTable) do
        local blocked = GetBlocked(data.options, path, executedTable);

        if (not blocked) then
          ExecuteUpdateFunction(unpack(blockedValue));
        else
          blockedValues = true;
        end
      end

      totalRepeats = totalRepeats + 1;

      obj:Assert(totalRepeats < MAX_BLOCKS, "Cyclic dependency found");
    until (not blockedValues);

    ExecuteOrdered("last", data.options, data.updateFunctions, data.settings, executedTable);

    obj:PushTable(executedTable);
    obj:PushTable(blockedTable);
    data.executingAllUpdateFunctions = nil;
  end
end