local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, gui, obj = MayronUI:GetCoreComponents();
local Components = MayronUI:NewComponent("ConfigMenuComponents");

local unpack = _G.unpack;

local function Button_OnClick(self)
  if (obj:IsTable(self.data)) then
    self.OnClick(self, unpack(self.data));
  else
    self.OnClick(self);
  end
end

function Components.button(parent, config)
  local button;

  if (config.texture) then
    local container = tk:CreateFrame("Frame", parent);
    container:SetSize(config.width or 20, config.height or 20);

    button = tk:CreateFrame("Button", container);
    button:SetSize(config.texWidth or config.width or 20, config.texHeight or config.height or 20);
    button:SetPoint(config.point or "BOTTOM");

    button:SetNormalTexture(config.texture);
    button:SetHighlightAtlas("chatframe-button-highlight");
  else
    button = gui:CreateButton(parent, config.name, nil,
      config.tooltip, config.padding, config.minWidth);

    if (config.height) then
      button:SetHeight(config.height);
    end
  end

  button.OnClick = config.OnClick;
  button:SetScript("OnClick", Button_OnClick);

  if (config.texture) then
    button = button:GetParent();
  end

  button.centered = true;
  return button;
end