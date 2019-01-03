-- luacheck: ignore MayronUI self 143 631
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local Private = {};

local C_Timer, InCombatLockdown, WorldFrame, GetSpecializationInfo = _G.C_Timer, _G.InCombatLockdown, _G.WorldFrame, _G.GetSpecializationInfo;
local UIParent, CreateFrame, UnitIsAFK = _G.UIParent, _G.CreateFrame, _G.UnitIsAFK;
local MoveViewLeftStop, SetCVar, MoveViewLeftStart = _G.MoveViewLeftStop, _G.SetCVar, _G.MoveViewLeftStart;
local UnitSex, UnitRace, SetCursor, GetSpecialization = _G.UnitSex, _G.UnitRace, _G.SetCursor, _G.GetSpecialization;
local UnitPVPName, GetRealmName, UnitLevel, UnitClass = _G.UnitPVPName, _G.GetRealmName, _G.UnitLevel, _G.UnitClass;

-- Register Module ------------

local C_AfkDisplayModule = MayronUI:RegisterModule("AfkDisplay", "AFK Display");

-- Add Database Defaults ------

db:AddToDefaults("global.afkDisplay", {
    enabled = true,
    rotateCamera = true,
    playerModel = true,
    modelScale = 1,
});

-- Private functions ---------

function Private:StartTimer()
    if (Private.display:IsShown()) then
        Private.time = Private.time or 0;

        local time = string.format("%.2d:%.2d", (Private.time / 60) % 60, (Private.time % 60));
        Private.time = Private.time + 1;
        Private.display.time:SetText(time);

        C_Timer.After(1, Private.StartTimer);
    end
end

function Private:ResetDataText()
    self.time = 0;
    local dataFrame = self.display.dataFrame;

    local leftText = string.format(dataFrame.left.label, dataFrame.left.num);
    dataFrame.left.num = 0;
    dataFrame.left:SetText(leftText);

    local rightText = string.format(dataFrame.right.label, dataFrame.right.num);
    dataFrame.right.num = 0;
    dataFrame.right:SetText(rightText);
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
    KulTiranHuman = {
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
    ZandalariTroll = {
        Male = {
            value = -0.4,
            hoverValue = -0.2,
        },
        Female = {
            value = -0.3,
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
};

----------------------------
-- Model Related Functions
----------------------------
do
    local Animator = {};

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
    local scale = db.global.afkDisplay.modelScale;
    Private.Y_POSITION = 100;

    local modelFrame = CreateFrame("Frame", nil, self.display);
    modelFrame:SetSize(200, 500 * scale);
    modelFrame:SetPoint("BOTTOMLEFT", self.display, "BOTTOMLEFT", 100, Private.Y_POSITION);
    tk:MakeMovable(modelFrame);

    modelFrame.model = CreateFrame("PlayerModel", nil, modelFrame);
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
    local function IncrementCounter(self)
        self.f.num = (self.f.num or 0) + 1;
        self.f:SetText(string.format(self.f.label, self.f.num));
    end

    function Private:CreateDisplay()
        if (self.display) then
            return self.display;
        end

        local display = CreateFrame("Frame", "MUI_AFKDisplayFrame", WorldFrame);
        display:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, -100);
        display:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, -100);
        display:SetHeight(150);

        display.bg = tk:SetBackground(display, tk:GetAssetFilePath("Textures\\BottomUI\\Single"));
        tk:ApplyThemeColor(display.bg);

        UIParent:HookScript("OnShow", function()
            local afkDisplay = MayronUI:ImportModule("AfkDisplay");
            afkDisplay:SetShown(false);
        end);

        display.time = display:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge");
        display.time:SetPoint("TOP", 0, -16);

        display.name = display:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        display.name:SetJustifyH("RIGHT");
        display.name:SetPoint("TOPRIGHT", -100, -14);

        local specType;
        if (GetSpecialization()) then
            specType = (select(2, GetSpecializationInfo(GetSpecialization()))).." ";
        else
            specType = tk.Strings.Empty;
        end

        local name = tk.Strings:Concat(UnitPVPName("player"), " - ",
            GetRealmName(), "\nLevel ", UnitLevel("player"), ", ",
            tk.Strings:SetTextColorByClass(tk.Strings:Concat(specType, (select(1, UnitClass("player"))))));

        display.name:SetText(name);

        display.titleButton = tk:PopFrame("Button", display);
        display.titleButton:SetSize(250, 22);
        display.titleButton:SetPoint("BOTTOM", display.bg, "TOP", 0, -1);

        local nameTexturePath = tk:GetAssetFilePath("Textures\\BottomUI\\NamePanel");
        display.titleButton:SetNormalTexture(nameTexturePath);
        display.titleButton:SetHighlightTexture(nameTexturePath);

        tk:ApplyThemeColor(0.8, display.titleButton);
        display.titleButton:SetNormalFontObject("MUI_FontNormal");
        display.titleButton:SetHighlightFontObject("GameFontHighlight");
        display.titleButton:SetText("MayronUI Gen5");

        display.dataFrame = tk:PopFrame("Frame", display);
        display.dataFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 0, 30);
        display.dataFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT");

        display.dataFrame.center = tk:PopFrame("Button", display.dataFrame);
        display.dataFrame.center:SetSize(100, 20);
        display.dataFrame.center:SetPoint("CENTER");
        display.dataFrame.center:SetNormalFontObject("GameFontHighlight");

        display.dataFrame.left = tk:PopFrame("Button", display.dataFrame);
        display.dataFrame.left:SetSize(100, 20);
        display.dataFrame.left:SetPoint("RIGHT", display.dataFrame.center, "LEFT", -20, 0);
        display.dataFrame.left:SetNormalFontObject("GameFontHighlight");

        display.dataFrame.right = tk:PopFrame("Button", display.dataFrame);
        display.dataFrame.right:SetSize(100, 20);
        display.dataFrame.right:SetPoint("LEFT", display.dataFrame.center, "RIGHT", 20, 0);
        display.dataFrame.right:SetNormalFontObject("GameFontHighlight");

        display.dataFrame.left:SetText(L["Whispers"]..": 0");
        display.dataFrame.right:SetText(L["Guild Chat"]..": 0");
        display.dataFrame.right.label = L["Guild Chat"]..": %u";
        display.dataFrame.left.label = L["Whispers"]..": %u";

        em:CreateEventHandler("CHAT_MSG_WHISPER", IncrementCounter).f = display.dataFrame.left;
        em:CreateEventHandler("CHAT_MSG_BN_WHISPER", IncrementCounter).f = display.dataFrame.left;
        em:CreateEventHandler("CHAT_MSG_GUILD", IncrementCounter).f = display.dataFrame.right;

        return display;
    end
end

-- C_AfkDisplayModule Module -----------

function C_AfkDisplayModule:OnInitialize(data)
    data.settings = db.global.afkDisplay:GetUntrackedTable();

    if (data.settings.enabled) then
        self:SetEnabled(true);
    end
end

function C_AfkDisplayModule:OnEnable(data)
    if (not data.handler) then
        data.handler = em:CreateEventHandler("PLAYER_FLAGS_CHANGED", function(_, _, unitID)
            if (unitID ~= "player" or not data.settings.enabled) then
                return;
            end

            self:SetShown(UnitIsAFK(unitID));
        end);

        em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
            self:SetShown(false);
        end);
    end
end

function C_AfkDisplayModule:SetShown(data, show)
    if (InCombatLockdown() or (_G.AuctionFrame and _G.AuctionFrame:IsVisible())) then
        -- Do not show AFK Display (even if player is AFK)
        -- if player is using the Auction house or player is in combat
        if (Private.display) then
            Private.display:Hide();
        end

        return;
    end

    if (show) then
        -- Hide UIParent and show AFK Display
        UIParent:Hide();
        MoveViewLeftStart(0.01);

        if (not Private.display) then
            Private.display = Private:CreateDisplay();

            if (data.settings.playerModel) then
                Private.display.modelFrame = Private:CreatePlayerModel();
            end
        end

        Private.display:Show();
        Private:PositionModel();
        Private:ResetDataText();
        Private:StartTimer();
    else
        -- Hide AFK Display and show UIParent
        UIParent:Show();

        if (data.settings.rotateCamera) then
            MoveViewLeftStop();
            SetCVar("cameraView", "0");
        end

        if (Private.display) then
            Private.display:Hide();
        end
    end
end