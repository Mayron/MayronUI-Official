local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, _, obj = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local ipairs = _G.ipairs;

-- supported textfield config attributes:
-- loops - a number for the total number of loops to call the function
-- args - an index table (no keys) of values to pass
-- func - the function to call with the loop id and arg (if using args)

-- you can only use either the "loops" or "args" attribute, but not both!
-- the function should return 1 widget per execution

-- should return a table of children created during the loop
function Components.loop(_, config)
  local children = obj:PopTable();

  if (config.OnLoad) then
    config.OnLoad(config);
    config.OnLoad = nil;
  end

  if (config.loops) then
    -- rather than args, you specify the number of times to loop
    for id = 1, config.loops do
      children[id] = config.func(id, config);
    end

  elseif (config.args) then
    for id, arg in ipairs(config.args) do
      -- func returns the children data to be loaded
      children[id] = config.func(id, arg, config);
    end
  end

  tk.Tables:CleanIndexes(children);

  return children;
end