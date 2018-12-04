------------------------
-- Setup namespaces
------------------------
local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local C_ChatModule = namespace.C_ChatModule;
local chatModule = MayronUI:ImportModule("Chat");

--TODO
function C_ChatModule:OnConfigUpdate(data, list, value)
	local key = list:PopFront();
	
    if (key == "profile" and list:PopFront() == "chat") then
		key = list:PopFront();
		
        if (key == "data") then
			local chatID = list:PopFront();
			
            if (chatID) then
				local cf = chat.chatFrames[self:GetChatNameById(chatID)];
				
				if (not cf) then 
					return; 
				end

                if (list:PopFront() == "buttons") then
					local buttonSetId, buttonID = list:PopFront(), list:PopFront();
					
                    if (buttonSetId and buttonSetId == 1 and buttonID) then
                        if (buttonID == 1) then
                            cf.left:SetText(value);
                        elseif (buttonID == 2) then
                            cf.middle:SetText(value);
                        elseif (buttonID == 3) then
                            cf.right:SetText(value);
                        end
                    end
                end
			end			
        elseif (key == "editBox") then
            key = list:PopFront();
            if (key == "yOffset") then
                ChatFrame1EditBox:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", -3, value);
				ChatFrame1EditBox:SetPoint("TOPRIGHT", ChatFrame1, "BOTTOMRIGHT", 3, value);
				
            elseif (key == "height") then
				ChatFrame1EditBox:SetHeight(value);
				
            elseif (key == "border" or key == "inset" or key == "borderSize") then
                local r, g, b, a = ChatFrame1EditBox:GetBackdropColor();
				local inset = (key == "inset" and value) or self.sv.editBox.inset;
				
                local backdrop = {
                    bgFile = "Interface\\Buttons\\WHITE8X8",
                    insets = {left = inset, right = inset, top = inset, bottom = inset};
				};
				
                backdrop.edgeFile = tk.Constants.LSM:Fetch("border", (key == "border" and value) or self.sv.editBox.border);
				backdrop.edgeSize = (key == "borderSize" and value) or self.sv.editBox.borderSize;
				
                ChatFrame1EditBox:SetBackdrop(backdrop);
                ChatFrame1EditBox:SetBackdropColor(r, g, b, a);
            elseif (key == "backdropColor") then
                ChatFrame1EditBox:SetBackdropColor(value.r, value.g, value.b, value.a);
            end
        end
    end
end

local function CreateButtonConfigData(dbPath, buttonID)
    local configData = {};

    if (buttonID == 1) then
        table.insert(configData, {   
            name = L["Standard Chat Buttons"],
            type = "title"
        });
    else
        table.insert(configData, {   
            name = string.format("Chat Buttons with Modifier Key %d", buttonID),
            type = "title"
        });
    end

    table.insert(configData, {   
        name = L["Left Button"],
        dbPath = string.format("%s.buttons[%d][1]", dbPath, buttonID)
    });

    table.insert(configData, {   
        name = L["Middle Button"],
        dbPath = string.format("%s.buttons[%d][2]", dbPath, buttonID)
    });

    table.insert(configData, {   
        name = L["Right Button"],
        dbPath = string.format("%s.buttons[%d][3]", dbPath, buttonID)
    });


    table.insert(configData, { type = "divider" });

    if (buttonID == 1) then
        return unpack(configData);
    end

    for _, modKey in tk.Tables:IterateArgs(L["Control"], L["Shift"], L["Alt"]) do
        local modKeyFirstChar = string.sub(modKey, 1, 1);

        table.insert(configData, {
            name = modKey,
            height = 40,
            type = "check",
            dbPath = string.format("%s.buttons[%d].key", dbPath, buttonID),

            GetValue = function(_, currentValue)
                return currentValue and currentValue:find(modKeyFirstChar);
            end,

            SetValue = function(dbPath, oldValue, newValue)
                value = value and modKeyFirstChar;

                if (not value and oldValue and oldValue:find(modKeyFirstChar)) then
                    newValue = oldValue:gsub("S", tk.Strings.Empty); -- remove it
                    db:SetPathValue(dbPath, newValue);
                else
                    newValue = (oldValue and tk.Strings:Join(oldValue, value)) or newValue; -- add it
                    db:SetPathValue(dbPath, newValue);
                end
            end
        });

    end

    return unpack(configData);
end

chatModule.ConfigData = 
{
    name = "Chat",
    type = "category",
    module = "Chat",
    children = {
        {   name = L["Edit Box (Message Input Box)"],
            type = "title",
            paddingTop = 0
        },
        {   name = L["Y-Offset"],
            type = "textfield",
            valueType = "number",
            tooltip = "Set the vertical positioning of the edit box.\n\nDefault is -8.",
            dbPath = "profile.chat.edit_box.yOffset"
        },
        {   name = L["Height"],
            type = "textfield",
            valueType = "number",
            tooltip = "The height of the edit box.\n\nDefault is 27.",
            dbPath = "profile.chat.edit_box.height"
        },
        { type = "divider",
        },
        {   name = L["Border"],
            type = "dropdown",
            options = tk.Constants.LSM:List("border"),
            dbPath = "profile.chat.edit_box.border",
        },
        {   name = L["Background Color"],
            type = "color",
            height = 64,
            dbPath = "profile.chat.edit_box.backdrop_color"
        },
        { type = "divider",
        },
        {   name = L["Border Size"],
            type = "textfield",
            valueType = "number",
            tooltip = L["Set the border size.\n\nDefault is 1."],
            dbPath = "profile.chat.edit_box.border_size"
        },
        {   name = L["Backdrop Inset"],
            type = "textfield",
            valueType = "number",
            tooltip = L["Set the spacing between the background and the border.\n\nDefault is 0."],
            dbPath = "profile.chat.edit_box.inset"
        },
        {   name = L["Chat Frame Options"],
            type = "title",
        },
        {   name = L["Button Swapping in Combat"],
            type = "check",
            tooltip = L["Allow the use of modifier keys to swap chat buttons while in combat."],
            dbPath = "profile.chat.swapInCombat",
        },
        {   type = "divider" 
        },
        {   type = "loop",
            args = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"},

            func = function(id, chatFrameName)
                local dbPath = string.format("profile.chat.chatFrames.%s", chatFrameName);
                local chatFrameLabel;

                if (tk.Strings:Contains(chatFrameName, "TOP")) then
                    chatFrameLabel = "Top";
                else
                    chatFrameLabel = "Bottom";
                end

                if (tk.Strings:Contains(chatFrameName, "LEFT")) then
                    chatFrameLabel = tk.Strings:JoinWithSpace(chatFrameLabel, "Left");
                else
                    chatFrameLabel = tk.Strings:JoinWithSpace(chatFrameLabel, "Right");
                end

                local configData =  
                {
                    name = tk.Strings:JoinWithSpace(chatFrameLabel, L["Options"]),
                    type = "submenu",
                    module = "Chat",
                    inherit = {
                        type = "dropdown",
                        options = namespace.ButtonNames,
                    },
                    children = { -- shame I can't loop this
                        {   name = L["Enable Chat Frame"],
                            type = "check",
                            requires_reload = true,
                            dbPath = string.format("%s.enabled", dbPath),
                        },
                    }
                };

                for i = 1, 3 do
                    tk.Tables:AddAll(configData.children, CreateButtonConfigData(dbPath, i));
                end

                return configData;
            end
        },
    }
};