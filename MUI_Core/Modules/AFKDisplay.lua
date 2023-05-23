-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local Private = {};

local select, string = _G.select, _G.string;
local C_Timer, InCombatLockdown, WorldFrame, UnitIsAFK = _G.C_Timer, _G.InCombatLockdown, _G.WorldFrame, _G.UnitIsAFK;
local GetSpecializationInfo = _G.GetSpecializationInfo;
local MoveViewLeftStop, MoveViewLeftStart = _G.MoveViewLeftStop, _G.MoveViewLeftStart;
local UnitSex, UnitRace, SetCursor, GetSpecialization = _G.UnitSex, _G.UnitRace, _G.SetCursor, _G.GetSpecialization;
local UnitPVPName, GetRealmName, UnitLevel, UnitClass = _G.UnitPVPName, _G.GetRealmName, _G.UnitLevel, _G.UnitClass;
local table, ipairs, HelpTip = _G.table, _G.ipairs, _G.HelpTip;

-- Register Module ------------
local C_AFKDisplayModule = MayronUI:RegisterModule("AFKDisplay", L["AFK Display"]);

-- Add Database Defaults ------
db:AddToDefaults("global.AFKDisplay", {
  enabled       = true;
  rotateCamera  = true;
  playerModel   = true;
  modelScale    = 1;
});

-- Private functions ---------

function Private:ResetDataText()
  self.time = 0;
  local left = self.display.left;
  local right = self.display.right;

  left:Disable();
  left.icon:Hide();
  right:Disable();
  right.icon:Hide();

  left.num = 0;
  right.num = 0;

  obj:PushTable(left.messages);
  left.messages = obj:PopTable();

  obj:PushTable(right.messages);
  right.messages = obj:PopTable();

  local leftText = string.format(left.label, left.num);
  left:SetText(leftText);

  local rightText = string.format(right.label, right.num);
  right:SetText(rightText);

  local listener = em:GetEventListenerByID("AFKDisplay_Messages");
  listener:SetEnabled(true);

  if (tk:IsRetail()) then
    HelpTip:HideAll(self.display);
  end
end

-- prevents cutting of models
Private.Races = { -- lower values = lower model
  Human = {
    Male = {
      value = -0.4,
      hoverValue = -0.3,
    },
    Female = {
      value = -0.4,
      hoverValue = -0.4,
    }
  },
  KulTiran = {
    Male = {
      value = -0.4,
      hoverValue = -0.3,
    },
    Female = {
      value = -0.4,
      hoverValue = -0.4,
  }
  },
  Dwarf = {
    Male = {
      value = -0.3,
      hoverValue = -0.2,
    },
    Female = {
      value = -0.4,
      hoverValue = -0.3,
    }
  },
  DarkIronDwarf = {
    Male = {
      value = -0.3,
      hoverValue = -0.2,
    },
    Female = {
      value = -0.4,
      hoverValue = -0.3,
    }
  },
  NightElf = {
    Male = {
      value = -0.5,
      hoverValue = -0.6,
    },
    Female = {
      value = -0.4,
      hoverValue = -0.6,
    }
  },
  VoidElf = {
    Male = {
      value = -0.5,
      hoverValue = -0.6,
    },
    Female = {
      value = -0.4,
      hoverValue = -0.6,
    }
  },
  Gnome = {
    Male = {
      value = -0.3,
      hoverValue = -0.3,
    },
    Female = {
      value = -0.3,
      hoverValue = -0.3,
    }
  },
  Draenei = {
    Male = {
      value = -0.4,
      hoverValue = -0.7,
    },
    Female = {
      value = -0.5,
      hoverValue = -0.7,
    }
  },
  LightforgedDraenei = {
    Male = {
      value = -0.4,
      hoverValue = -0.7,
    },
    Female = {
      value = -0.5,
      hoverValue = -0.7,
    }
  },
  Worgen = {
    Male = {
      value = -0.4,
      hoverValue = -0.4,
    },
    Female = {
      value = -0.4,
      hoverValue = -0.4,
    }
  },
  Pandaren = {
    Male = {
      value = -0.6,
      hoverValue = -0.9,
    },
    Female = {
      value = -0.4,
      hoverValue = -0.3,
    }
  },
  Orc = {
    Male = {
      value = -0.4,
      hoverValue = -0.4,
    },
    Female = {
      value = -0.5,
      hoverValue = -0.4,
    }
  },
  MagharOrc = {
    Male = {
      value = -0.4,
      hoverValue = -0.4,
    },
    Female = {
      value = -0.5,
      hoverValue = -0.4,
    }
  },
  Scourge = {
    Male = {
      value = -0.4,
      hoverValue = -0.6,
    },
    Female = {
      value = -0.4,
      hoverValue = -0.4,
    }
  },
  Tauren = {
    Classic = {
      Male = {
        value = -0.5,
        hoverValue = -0.4,
      },
    },
    Male = {
      value = -0.3,
      hoverValue = -0.4,
    },
    Female = {
      value = -0.6,
      hoverValue = -0.4,
    }
  },
  HighmountainTauren = {
    Male = {
      value = -0.3,
      hoverValue = -0.4,
    },
    Female = {
      value = -0.6,
      hoverValue = -0.4,
    }
  },
  Nightborne = {
    Male = {
      value = -0.5,
      hoverValue = -0.6,
    },
    Female = {
      value = -0.4,
      hoverValue = -0.6,
    }
  },
  Troll = {
    Male = {
      value = -0.4,
      hoverValue = -0.2,
    },
    Female = {
      value = -0.3,
      hoverValue = -0.5,
    }
  },
  Mechagnome = {
    Male = {
      value = -0.3,
      hoverValue = -0.3,
    },
    Female = {
      value = -0.3,
      hoverValue = -0.3,
    }
  },
  Vulpera = {
    Male = {
      value = -0.3,
      hoverValue = -0.3,
    },
    Female = {
      value = -0.3,
      hoverValue = -0.4,
    }
  },
  ZandalariTroll = {
    Male = {
      value = -0.4,
      hoverValue = -0.2,
    },
    Female = {
      value = -0.6,
      hoverValue = -0.5,
    }
  },
  BloodElf = {
    Male = {
      value = -0.5,
      hoverValue = -0.8,
    },
    Female = {
      value = -0.4,
      hoverValue = -0.9,
    }
  },
  Goblin = {
    Male = {
      value = -0.3,
      hoverValue = -0.3,
    },
    Female = {
      value = -0.3,
      hoverValue = -0.3,
    }
  },
  Dracthyr = {
    Male = {
      value = -0.1,
      hoverValue = -0.4,
    },
    Female = {
      value = -0.1,
      hoverValue = -0.4,
    }
  },
};

----------------------------
-- Model Related Functions
----------------------------
do
  local Animator = obj:PopTable();

  function Animator:TransitionValue()
    local _, _, yValue = Animator.model:GetPosition();

    if (Animator.step > 0) then
      if (yValue >= Animator.endValue) then
        Animator.model:SetPosition(-0.3, 0, Animator.endValue);
        return;
      end

    else
      if (yValue <= Animator.endValue) then
        Animator.model:SetPosition(-0.3, 0, Animator.endValue);
        return;
      end
    end

    Animator.model:SetPosition(-0.3, 0, yValue + Animator.step);
    C_Timer.After(0.01, Animator.TransitionValue);
  end

  function Private:PositionModel(hovering, falling)
    local gender = UnitSex("player");
    gender = (gender == 2) and "Male" or "Female";

    local race = (select(2, UnitRace("player"))):gsub("%s+", "");
    local tbl = Private.Races[race][gender];

    if (not tk:IsRetail()) then
      local classicTbl = Private.Races[race].Classic;
      classicTbl = obj:IsTable(classicTbl) and classicTbl[gender];
      tbl = obj:IsTable(classicTbl) and classicTbl or tbl;
    end

    local value = (hovering and tbl.hoverValue) or tbl.value;
    local model = self.display.modelFrame.model;

    model:SetPoint("BOTTOM");

    if (not falling) then
      model:SetPosition(-0.3, 0, value);
      return;
    end

    local _, _, yValue = model:GetPosition();
    local difference = value - yValue;

    Animator.endValue = value;
    Animator.model = model;

    if (difference > 0) then
      Animator.step = 0.03;
      C_Timer.After(0.01, Animator.TransitionValue);

    elseif (difference < 0) then
      Animator.step = -0.03;
      C_Timer.After(0.01, Animator.TransitionValue);

    else
      model:SetPosition(-0.3, 0, value);
    end
  end
end

function Private:StartFalling()
    local modelFrame = Private.display.modelFrame;

    if (not modelFrame) then
        return;
    end

    local point, relativeFrame, relativePoint, xOffset, yOffset = modelFrame:GetPoint();

    if (yOffset > Private.Y_POSITION) then
        modelFrame:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset - 10); -- 10 is the step value
        C_Timer.After(0.01, Private.StartFalling);
    else
        if (yOffset < Private.Y_POSITION) then
            modelFrame:SetPoint(point, relativeFrame, relativePoint, xOffset, Private.Y_POSITION);
            Private:PositionModel(nil, true);
        end

        modelFrame.model:SetAnimation(39);
        modelFrame.model.dragging = nil;
    end
end

function Private:StartRotating()
  if (not Private.display.modelFrame) then
    return;
  end

  local modelFrame = Private.display.modelFrame;

  if (modelFrame.model.dragging) then
    local scaledScreenWidth = UIParent:GetWidth() * UIParent:GetScale();
    local modelPoint = modelFrame:GetLeft() + ((modelFrame:GetWidth()) / 2);

    local rotation = (scaledScreenWidth - modelPoint) - (scaledScreenWidth * 0.5);
    modelFrame.model:SetFacing(rotation / 1000);

    local justify = Private.display.name:GetJustifyH();

    if (modelPoint > (scaledScreenWidth * 0.5)) then
      if (justify == "RIGHT") then
        Private.display.name:SetJustifyH("LEFT");
        Private.display.name:ClearAllPoints();
        Private.display.name:SetPoint("TOPLEFT", Private.display, "TOPLEFT", 100, -14);
      end
    else
      if (justify == "LEFT") then
        Private.display.name:SetJustifyH("RIGHT");
        Private.display.name:ClearAllPoints();
        Private.display.name:SetPoint("TOPRIGHT", -100, -14);
      end
    end

    C_Timer.After(0.01, Private.StartRotating);
  end
end

function Private:CreatePlayerModel()
  local scale = db.global.AFKDisplay.modelScale;
  Private.Y_POSITION = 100;

  local modelFrame = tk:CreateFrame("Frame", self.display);
  modelFrame:SetSize(200, 500 * scale);
  modelFrame:SetPoint("BOTTOMLEFT", self.display, "BOTTOMLEFT", 100, Private.Y_POSITION);
  tk:MakeMovable(modelFrame);

  modelFrame.model = tk:CreateFrame("PlayerModel", modelFrame);
  modelFrame.model:SetSize(600 * scale, 700 * scale);
  modelFrame.model:SetUnit("player");
  modelFrame.model:SetFacing(0.4);

  modelFrame:SetScript("OnMouseUp", function(self)
    self.model:SetAnimation(8);
  end);

  modelFrame:SetScript("OnEnter", function()
    SetCursor("Interface\\CURSOR\\UI-Cursor-Move.blp");
  end)

  modelFrame.model:SetScript("OnAnimFinished", function(self)
    if (self.dragging) then
      self:SetAnimation(38);
    else
      self:SetAnimation(0);
    end
  end)

  modelFrame:HookScript("OnDragStart", function(self)
    self:SetClampedToScreen(true);
    self.model.dragging = true;
    self.model:SetAnimation(38);
    Private:PositionModel(true);
    Private:StartRotating();
  end)

  modelFrame:HookScript("OnDragStop", function(self)
    self:SetClampedToScreen(false) -- so it can fall lower off the screen
    local left = self:GetLeft();
    local bottom = self:GetBottom();

    self:ClearAllPoints();
    self:SetPoint("BOTTOMLEFT", Private.display, "BOTTOMLEFT", left, bottom);
    Private:StartFalling();
  end);

  return modelFrame;
end

do
  local messageFormat = "%s[%s]: %s";
  local GameTime_GetTime = _G.GameTime_GetTime;
  local ChatTypeInfo = _G.ChatTypeInfo;
  local Chat_GetChannelColor = _G.Chat_GetChannelColor;

  local function IncrementCounter(self, event, display, message, source)
    local frame = display.left;

    if (event == "CHAT_MSG_GUILD") then
      frame = display.right;
    end

    frame.num = (frame.num or 0) + 1;
    frame:SetText(string.format(frame.label, frame.num));

    local timestamp = string.format("[%s] ", (select(1, GameTime_GetTime())));
    timestamp = tk.Strings:SetTextColorByKey(timestamp, "GRAY");
    table.insert(frame.messages, string.format(messageFormat, timestamp, source, message));

    frame:Enable();
    frame.icon:Show();

    if (tk:IsRetail()) then
      HelpTip:Show(display, display.helpTipInfo, frame);
    end
  end

  local function RefreshChatText(editBox)
    obj:Assert(ChatTypeInfo[editBox.chatType], "Invalid chat type \"%s\"", editBox.chatType);

    local r, g, b = Chat_GetChannelColor(ChatTypeInfo[editBox.chatType]);
    local messages = obj:PopTable();

    for _, message in ipairs(editBox.messages) do
      if (obj:IsString(message) and #message > 0) then
        -- |Km26|k (BSAp) or |Kq%d+|k
        message = message:gsub("|K.*|k", tk.ReplaceAccountNameCodeWithBattleTag);
        message = tk.Strings:SetTextColorByRGB(message, r, g, b);

        table.insert(messages, message);
      end
    end

    local fullText = table.concat(messages, " \n", 1, #messages);
    editBox:SetText(fullText);
    obj:PushTable(messages);
  end

  function Private:ShowCopyChatFrame(messages, chatType)
    if (self.copyChatFrame) then
      self.copyChatFrame.editBox.messages = messages;
      self.copyChatFrame.editBox.chatType = chatType;
      self.chatTypeDropdown:SetLabel(chatType == "WHISPER" and L["Whispers"] or L["Guild Chat"]);
      self.copyChatFrame:Show();
      return;
    end

    local frame = tk:CreateFrame("Frame", WorldFrame);
    frame:SetSize(600, 300);
    frame:SetPoint("CENTER");
    frame:SetScale(_G.UIParent:GetScale());
    frame:SetScript("OnShow", function()
      RefreshChatText(self.copyChatFrame.editBox);
    end);

    self.copyChatFrame = frame;

    gui:AddDialogTexture(frame);
    gui:AddCloseButton(frame);
    gui:AddTitleBar(frame, L["Copy Chat Text"]);

    local editBox = tk:CreateFrame("EditBox", frame);
    editBox:SetMultiLine(true);
    editBox:SetMaxLetters(99999);
    editBox:EnableMouse(true);
    editBox:SetAutoFocus(false);
    editBox:SetFontObject("GameFontHighlight");
    editBox:SetHeight(200);
    editBox.messages = messages;
    editBox.chatType = chatType;
    self.copyChatFrame.editBox = editBox;

    editBox:SetScript("OnEscapePressed", function(self)
      self:ClearFocus();
    end);

    local refreshButton = tk:CreateFrame("Button", frame);
    refreshButton:SetSize(18, 18);
    refreshButton:SetPoint("TOPRIGHT", frame.closeBtn, "TOPLEFT", -10, -3);
    refreshButton:SetNormalTexture(tk:GetAssetFilePath("Textures\\refresh"));

    tk:ApplyThemeColor(refreshButton:GetNormalTexture());

    refreshButton:SetHighlightAtlas("chatframe-button-highlight");
    tk:SetBasicTooltip(refreshButton, L["Refresh Chat Text"]);

    refreshButton:SetScript("OnClick", function()
      RefreshChatText(editBox);
    end);

    local dropdown = gui:CreateDropDown(frame, nil, frame);
    local dropdownContainer = dropdown:GetFrame();
    dropdownContainer:SetSize(150, 20);
    dropdownContainer:SetPoint("TOPRIGHT", refreshButton, "TOPLEFT", -10, 0);

    local function DropDown_OnOptionSelected(_, value)
      if (value == "WHISPER") then
        editBox.messages = self.display.left.messages;
        editBox.chatType = value;
      else
        editBox.messages = self.display.right.messages;
        editBox.chatType = value;
      end

      RefreshChatText(editBox);
    end

    dropdown:AddOption(L["Whispers"], DropDown_OnOptionSelected, "WHISPER");
    dropdown:AddOption(L["Guild Chat"], DropDown_OnOptionSelected, "GUILD");
    dropdown:SetLabel(chatType == "WHISPER" and L["Whispers"] or L["Guild Chat"]);

    self.chatTypeDropdown = dropdown;

    local container = gui:CreateScrollFrame(frame, nil, editBox);
    container:SetPoint("TOPLEFT", 10, -30);
    container:SetPoint("BOTTOMRIGHT", -10, 10);

    container.ScrollFrame:ClearAllPoints();
    container.ScrollFrame:SetPoint("TOPLEFT", 5, -5);
    container.ScrollFrame:SetPoint("BOTTOMRIGHT", -5, 5);

    container.ScrollFrame:HookScript("OnScrollRangeChanged", function(self)
      local maxScroll = self:GetVerticalScrollRange();
      self:SetVerticalScroll(maxScroll);
    end);

    tk:SetBackground(container, 0, 0, 0, 0.4);
    RefreshChatText(self.copyChatFrame.editBox);
  end

  function Private:CreateDisplay()
    if (self.display) then return self.display; end

    local display = tk:CreateFrame("Frame", WorldFrame);
    display:SetPoint("BOTTOMLEFT", WorldFrame, "BOTTOMLEFT", 0, -100);
    display:SetPoint("BOTTOMRIGHT", WorldFrame, "BOTTOMRIGHT", 0, -100);
    display:SetHeight(150);

    display.bg = tk:SetBackground(display, tk:GetAssetFilePath("Textures\\BottomUI\\Single"));
    tk:ApplyThemeColor(display.bg);

    display.time = display:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge");
    display.time:SetPoint("TOP", 0, -16);
    display.time:SetWidth(100);

    display.name = display:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    display.name:SetJustifyH("RIGHT");
    display.name:SetPoint("TOPRIGHT", -100, -14);

    display.titleBar = tk:CreateFrame("Frame", display);

    display.titleBar:SetSize(200, 22);
    display.titleBar:SetPoint("BOTTOM", display.bg, "TOP", 0, -1);

    local nameTexturePath = tk:GetAssetFilePath("Textures\\BottomUI\\NamePanel");
    local titleTexture = display.titleBar:CreateTexture(nil, "BACKGROUND");
    titleTexture:SetTexture(nameTexturePath);
    titleTexture:SetAllPoints(true);
    tk:ApplyThemeColor(0.8, titleTexture);

    local txt = display.titleBar:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
    txt:SetPoint("CENTER");
    txt:SetText("MayronUI");
    tk:SetFontSize(txt, 11);

    display.left = tk:CreateFrame("Button", display);
    display.left:SetDisabledFontObject("GameFontDisable");
    display.left:SetHighlightFontObject("GameFontNormal");
    display.left:Disable();
    display.left:SetSize(100, 30);
    display.left:SetPoint("RIGHT", display.time, "LEFT", -20, 0);
    display.left:SetNormalFontObject("GameFontHighlight");
    display.left.messages = obj:PopTable();
    display.left:SetScript("OnClick", function()
      self:ShowCopyChatFrame(display.left.messages, "WHISPER");

      if (tk:IsRetail()) then
        HelpTip:HideAll(display);
      end
    end);

    display.left.icon = display.left:CreateTexture(nil, "BACKGROUND");
    display.left.icon:SetTexture(tk:GetAssetFilePath("Textures\\available.blp"));
    display.left.icon:SetSize(15, 15);
    display.left.icon:SetPoint("LEFT", -5, 0);
    display.left.icon:Hide();

    if (tk:IsRetail()) then
      display.helpTipInfo = {
        text = "You have new messages!",
        targetPoint = HelpTip.Point.TopEdgeCenter,
        buttonStyle = HelpTip.ButtonStyle.Close,
        offsetY = 0,
      };
    end

    display.right = tk:CreateFrame("Button", display);
    display.right:SetDisabledFontObject("GameFontDisable");
    display.right:SetHighlightFontObject("GameFontNormal");
    display.right:Disable();
    display.right:SetSize(100, 20);
    display.right:SetPoint("LEFT", display.time, "RIGHT", 20, 0);
    display.right:SetNormalFontObject("GameFontHighlight");
    display.right.messages = obj:PopTable();
    display.right:SetScript("OnClick", function()
      self:ShowCopyChatFrame(display.right.messages, "GUILD");

      if (tk:IsRetail()) then
        HelpTip:HideAll(display);
      end
    end);

    display.right.icon = display.right:CreateTexture(nil, "BACKGROUND");
    display.right.icon:SetTexture(tk:GetAssetFilePath("Textures\\available.blp"));
    display.right.icon:SetSize(15, 15);
    display.right.icon:SetPoint("LEFT", -5, 0);
    display.right.icon:Hide();

    display.left:SetText(L["Whispers"]..": 0");
    display.right:SetText(L["Guild Chat"]..": 0");
    display.right.label = L["Guild Chat"]..": %u";
    display.left.label = L["Whispers"]..": %u";

    local listener = em:CreateEventListenerWithID("AFKDisplay_Messages", IncrementCounter);
    listener:SetCallbackArgs(display);
    listener:RegisterEvents("CHAT_MSG_WHISPER", "CHAT_MSG_BN_WHISPER", "CHAT_MSG_GUILD");

    return display;
  end
end

function Private:HideDisplay()
  if (self.display) then
    self.display:Hide();

    local listener = em:GetEventListenerByID("AFKDisplay_Messages");
    listener:SetEnabled(false);

    if (self.copyChatFrame) then
      self.copyChatFrame:Hide();
    end
  end
end

-- C_AFKDisplayModule Module -----------

function C_AFKDisplayModule:OnInitialize(data)
  data.settings = db.global.AFKDisplay:GetUntrackedTable();

  if (data.settings.enabled) then
    self:SetEnabled(true);
  end
end

local function StartTimer()
  if (Private.display:IsShown()) then
    Private.time = Private.time or 0;

    local time = string.format("%.2d:%.2d", (Private.time / 60) % 60, (Private.time % 60));
    Private.time = Private.time + 1;
    Private.display.time:SetText(time);

    C_Timer.After(1, StartTimer);
  end
end

local function SetAFKDisplayShown(data, show)
  if (InCombatLockdown() or (_G.AuctionFrame and _G.AuctionFrame:IsVisible())
    or (_G.MovieFrame and _G.MovieFrame:IsShown())) then
    -- Do not show AFK Display (even if player is AFK)
    -- if player is using the Auction house or player is in combat
    Private:HideDisplay();
    return;
  end

  if (show) then
    -- Hide UIParent and show AFK Display
    _G.UIParent:Hide();
    MoveViewLeftStart(0.01);

    if (not Private.display) then
      Private.display = Private:CreateDisplay();

      if (data.settings.playerModel) then
        Private.display.modelFrame = Private:CreatePlayerModel();
      end
    end

    -- Get Player Level + Spec and update text:
    local specType;
    if (GetSpecialization) then
      specType = (select(2, GetSpecializationInfo(GetSpecialization()))).." ";
    else
      specType = tk.Strings.Empty;
    end

    local name = tk.Strings:Concat(UnitPVPName("player"), " - ",
    GetRealmName(), "\nLevel ", UnitLevel("player"), ", ",
    tk.Strings:SetTextColorByClassFileName(tk.Strings:Concat(specType, (select(1, UnitClass("player"))))));

    Private.display.name:SetText(name);
    Private.display:Show();

    Private:PositionModel();
    Private:ResetDataText();
    StartTimer();
  else
    -- Hide AFK Display and show UIParent
    _G.UIParent:Show();

    if (data.settings.rotateCamera) then
      MoveViewLeftStop();
    end

    Private:HideDisplay();
  end
end

function C_AFKDisplayModule:OnEnable(data)
  if (not data.eventListener) then
    data.eventListener = em:CreateEventListenerWithID("afkDisplayFlagsChanged", function(_, _, unitID)
      if (unitID ~= "player" or not data.settings.enabled) then
        return
      end

      local isAfk = UnitIsAFK(unitID);
      SetAFKDisplayShown(data, isAfk);
    end);

    data.eventListener:RegisterEvent("PLAYER_FLAGS_CHANGED");

    local regenDisabled = em:CreateEventListenerWithID("afkDisplayRegenDisabled", function()
      SetAFKDisplayShown(data, false);
    end);

    _G.UIParent:HookScript("OnShow", function()
      SetAFKDisplayShown(data, false);
    end);

    regenDisabled:RegisterEvent("PLAYER_REGEN_DISABLED");
  else
    em:EnableEventListeners("afkDisplayFlagsChanged", "afkDisplayRegenDisabled");
  end
end

function C_AFKDisplayModule:OnDisable(data)
  if (data.eventListener) then
    em:DisableEventListeners("afkDisplayFlagsChanged", "afkDisplayRegenDisabled");
  end
end