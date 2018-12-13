-- luacheck: ignore MayronUI self 143 631
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local Private = {};

-- Register Module ------------

local AfkDisplay = MayronUI:RegisterModule("AfkDisplay");

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
        local time = tk.string.format("%.2d:%.2d", (Private.time / 60) % 60, (Private.time % 60));
        Private.time = Private.time + 1;
        Private.display.time:SetText(time);

        -- Update dataFrame:
        --MUI_AFKFrame.dataFrame.CenterFrame.text:SetText(GameTime_GetTime(false))
        tk.C_Timer.After(1, Private.StartTimer);
    end
end

function Private:ResetDataText()
    self.time = 0;
    local f = self.display.dataFrame;
    f.left.num = 0;
    f.left:SetText(tk.string.format(f.left.label, f.left.num));
    f.right.num = 0;
    f.right:SetText(tk.string.format(f.right.label, f.right.num));
end

-- prevents cutting of models
Private.races = { -- lower = lower model
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
    tk.C_Timer.After(0.01, Animator.TransitionValue);
end

local function PositionModel(model, hovering, falling)
    local gender = _G.UnitSex("player");
    gender = (gender == 2) and "Male" or "Female";

    local race = (tk.select(2, _G.UnitRace("player"))):gsub("%s+", "");
    local tbl = Private.races[race][gender];
    local value = (hovering and tbl.hoverValue) or tbl.value;

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
        tk.C_Timer.After(0.01, Animator.TransitionValue);

    elseif (difference < 0) then
        Animator.step = -0.03;
        tk.C_Timer.After(0.01, Animator.TransitionValue);

    else
        model:SetPosition(-0.3, 0, value);
    end
end

function Private:StartFalling()
    if (not Private.display.modelFrame) then
        return;
    end

    local f = Private.display.modelFrame;
    local p, rf, rp, x, y = f:GetPoint();

    if (y > Private.Y_POSITION) then
        f:SetPoint(p, rf, rp, x, y - 10) -- 10 is the step value
        tk.C_Timer.After(0.01, Private.StartFalling);
    else
        if (y < Private.Y_POSITION) then
            f:SetPoint(p, rf, rp, x, Private.Y_POSITION);
            PositionModel(Private.display.modelFrame.model, nil, true);
        end

        f.model:SetAnimation(39);
        f.model.dragging = nil;
    end
end

function Private:StartRotating()
    if (not Private.display.modelFrame) then
        return;
    end

    local f = Private.display.modelFrame;

    if (f.model.dragging) then
        local scaledScreenWidth = tk.UIParent:GetWidth() * tk.UIParent:GetScale();
        local modelPoint = f:GetLeft() + ((f:GetWidth()) / 2);

        local rotation = (scaledScreenWidth - modelPoint) - (scaledScreenWidth * 0.5);
        f.model:SetFacing(rotation / 1000);

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
        tk.C_Timer.After(0.01, Private.StartRotating);
    end
end

function Private:CreatePlayerModel()
    local scale = db.global.afkDisplay.modelScale;
    Private.Y_POSITION = 100;

    local f = tk.CreateFrame("Frame", nil, self.display);
    f:SetSize(200, 500 * scale);
    f:SetPoint("BOTTOMLEFT", self.display, "BOTTOMLEFT", 100, Private.Y_POSITION)
    tk:MakeMovable(f);

    f.model = tk.CreateFrame("PlayerModel", nil, f);
    f.model:SetSize(600 * scale, 700 * scale);
    f.model:SetUnit("player");
    f.model:SetFacing(0.4);

    f:SetScript("OnMouseUp", function(self)
        self.model:SetAnimation(8);
    end)

    f:SetScript("OnEnter", function()
        _G.SetCursor("Interface\\CURSOR\\UI-Cursor-Move.blp");
    end)

    f.model:SetScript("OnAnimFinished", function(self)
        if (self.dragging) then
            self:SetAnimation(38);
        else
            self:SetAnimation(0);
        end
    end)

    f:HookScript("OnDragStart", function(self)
        self:SetClampedToScreen(true);
        self.model.dragging = true;
        self.model:SetAnimation(38);
        PositionModel(Private.display.modelFrame.model, true);
        Private:StartRotating();
    end)

    f:HookScript("OnDragStop", function(self)
        self:SetClampedToScreen(false) -- so it can fall lower off the screen
        local left = self:GetLeft()
        local bottom = self:GetBottom()
        self:ClearAllPoints()
        self:SetPoint("BOTTOMLEFT", Private.display, "BOTTOMLEFT", left, bottom)
        Private:StartFalling();
    end);

    return f;
end

do
    local function IncrementCounter(self)
        self.f.num = (self.f.num or 0) + 1;
        self.f:SetText(tk.string.format(self.f.label, self.f.num));
    end

    function Private:CreateDisplay()
        if (self.display) then
            return self.display;
        end

        local f = tk.CreateFrame("Frame", "MUI_AFKFrame", _G.WorldFrame);
        f:SetPoint("BOTTOMLEFT", tk.UIParent, "BOTTOMLEFT", 0, -100);
        f:SetPoint("BOTTOMRIGHT", tk.UIParent, "BOTTOMRIGHT", 0, -100);
        f:SetHeight(150);

        f.bg = tk:SetBackground(f, tk.Constants.MEDIA.."bottom_ui\\Single");
        tk:SetThemeColor(f.bg);

        _G.UIParent:HookScript("OnShow", function()
            AfkDisplay:Toggle(false);
        end);

        f.time = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge");
        f.time:SetPoint("TOP", 0, -16);

        f.name = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        f.name:SetJustifyH("RIGHT");
        f.name:SetPoint("TOPRIGHT", -100, -14);

        local specType;
        if (_G.GetSpecialization()) then
            specType = (select(2, _G.GetSpecializationInfo(_G.GetSpecialization()))).." ";
        else
            specType = "";
        end

        local name = tk.Strings:Concat(_G.UnitPVPName("player"), " - ",
            _G.GetRealmName(), "\nLevel ", _G.UnitLevel("player"), ", ",
            tk:GetClassColoredString(nil, tk.Strings:Concat(specType, _G.UnitClass("player"))));

        f.name:SetText(name);

        f.titleButton = tk:PopFrame("Button", f);
        f.titleButton:SetSize(250, 22);
        f.titleButton:SetPoint("BOTTOM", f.bg, "TOP", 0, -1);
        f.titleButton:SetNormalTexture(tk.Constants.MEDIA.."bottom_ui\\Names");
        f.titleButton:SetHighlightTexture(tk.Constants.MEDIA.."bottom_ui\\Names");
        tk:SetThemeColor(0.8, f.titleButton);
        f.titleButton:SetNormalFontObject("MUI_FontNormal");
        f.titleButton:SetHighlightFontObject("GameFontHighlight");
        f.titleButton:SetText("MayronUI Gen5");

        f.dataFrame = tk:PopFrame("Frame", f);
        f.dataFrame:SetPoint("TOPLEFT", tk.UIParent, "BOTTOMLEFT", 0, 30);
        f.dataFrame:SetPoint("BOTTOMRIGHT", tk.UIParent, "BOTTOMRIGHT");

        f.dataFrame.center = tk:PopFrame("Button", f.dataFrame);
        f.dataFrame.center:SetSize(100, 20);
        f.dataFrame.center:SetPoint("CENTER");
        f.dataFrame.center:SetNormalFontObject("GameFontHighlight");

        f.dataFrame.left = tk:PopFrame("Button", f.dataFrame);
        f.dataFrame.left:SetSize(100, 20);
        f.dataFrame.left:SetPoint("RIGHT", f.dataFrame.center, "LEFT", -20, 0);
        f.dataFrame.left:SetNormalFontObject("GameFontHighlight");

        f.dataFrame.right = tk:PopFrame("Button", f.dataFrame);
        f.dataFrame.right:SetSize(100, 20);
        f.dataFrame.right:SetPoint("LEFT", f.dataFrame.center, "RIGHT", 20, 0);
        f.dataFrame.right:SetNormalFontObject("GameFontHighlight");

        f.dataFrame.left:SetText(L["Whispers"]..": 0");
        f.dataFrame.right:SetText(L["Guild Chat"]..": 0");
        f.dataFrame.right.label = L["Guild Chat"]..": %u";
        f.dataFrame.left.label = L["Whispers"]..": %u";

        em:CreateEventHandler("CHAT_MSG_WHISPER", IncrementCounter).f = f.dataFrame.left;
        em:CreateEventHandler("CHAT_MSG_BN_WHISPER", IncrementCounter).f = f.dataFrame.left;
        em:CreateEventHandler("CHAT_MSG_GUILD", IncrementCounter).f = f.dataFrame.right;

        return f;
    end
end

-- AfkDisplay Module -----------

function AfkDisplay:OnInitialize(data)
    data.sv = db.global.afkDisplay;

    if (data.sv.enabled) then
        self:SetEnabled(true);
    end
end

function AfkDisplay:OnEnable(data)
    if (data.handler) then
        data.handler = em:CreateEventHandler("PLAYER_FLAGS_CHANGED", function(_, _, unitID)
            if (unitID ~= "player" or not data.sv.enabled) then
                return;
            end

            self:Toggle(_G.UnitIsAFK(unitID));
        end);

        em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
            self:Toggle(false);
        end);
    end
end

function AfkDisplay:Toggle(data, show)
    if (tk.InCombatLockdown() or (_G.AuctionFrame and _G.AuctionFrame:IsVisible())) then
        if (Private.display) then
            Private.display:Hide();
        end

        return;
    end

    if (show) then
        tk.UIParent:Hide();
        _G.MoveViewLeftStart(0.01);

        if (not Private.display) then
            Private.display = Private:CreateDisplay();

            if (data.sv.playerModel) then
                Private.display.modelFrame = Private:CreatePlayerModel();
            end
        end

        Private.display:Show();
        PositionModel(Private.display.modelFrame.model);
        Private:ResetDataText();
        Private:StartTimer();

    else
        tk.UIParent:Show();

        if (data.sv.rotateCamera) then
            _G.MoveViewLeftStop();
            _G.SetCVar("cameraView", "0"); -- to remove bug
        end

        if (Private.display) then
            Private.display:Hide();
        end
    end
end