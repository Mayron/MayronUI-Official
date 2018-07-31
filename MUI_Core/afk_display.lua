------------------------
-- Setup namespaces
------------------------
local _, core = ...;
local em = core.EventManager;
local tk = core.Toolkit;
local db = core.Database;

local afk = {};
local private = {};

db:AddToDefaults("global.afk", {
    enabled = true,
    rotateCamera = true,
    playerModel = true,
    modelScale = 1,
});

MayronUI:RegisterModule("AFK_Display", afk);

--------------------------
-- Private functions:
--------------------------
function private:StartTimer()
    if (private.display:IsShown()) then
        private.time = private.time or 0;
        local time = tk.string.format("%.2d:%.2d", (private.time / 60) % 60, (private.time % 60));
        private.time = private.time + 1;
        private.display.time:SetText(time);

        -- Update dataFrame:
        --MUI_AFKFrame.dataFrame.CenterFrame.text:SetText(GameTime_GetTime(false))
        tk.C_Timer.After(1, private.StartTimer);
    end
end

function private:ResetDataText()
    self.time = 0;
    local f = self.display.dataFrame;
    f.left.num = 0;
    f.left:SetText(tk.string.format(f.left.label, f.left.num));
    f.right.num = 0;
    f.right:SetText(tk.string.format(f.right.label, f.right.num));
end

-- prevents cutting of models
private.races = { -- lower = lower model
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
    MagharOrcs = {
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
local animator = {};
function animator:TransitionValue()
    local _, _, yValue = animator.model:GetPosition();
    if (animator.step > 0) then
        if (yValue >= animator.endValue) then
            animator.model:SetPosition(-0.3, 0, animator.endValue);
            return;
        end
    else
        if (yValue <= animator.endValue) then
            animator.model:SetPosition(-0.3, 0, animator.endValue);
            return;
        end
    end
    animator.model:SetPosition(-0.3, 0, yValue + animator.step);
    tk.C_Timer.After(0.01, animator.TransitionValue);
end

local function PositionModel(model, hovering, falling)
    local gender = UnitSex("player");
    gender = (gender == 2) and "Male" or "Female";
    local race = (tk.select(2, UnitRace("player"))):gsub("%s+", "");
    local tbl = private.races[race][gender];
    local value = (hovering and tbl.hoverValue) or tbl.value;
    model:SetPoint("BOTTOM");

    if (not falling) then
        model:SetPosition(-0.3, 0, value);
        return;
    end

    local _, _, yValue = model:GetPosition();
    local difference = value - yValue;
    animator.endValue = value;
    animator.model = model;
    if (difference > 0) then
        animator.step = 0.03;
        tk.C_Timer.After(0.01, animator.TransitionValue);
    elseif (difference < 0) then
        animator.step = -0.03;
        tk.C_Timer.After(0.01, animator.TransitionValue);
    else
        model:SetPosition(-0.3, 0, value);
    end
end

function private:StartFalling()
    if (not private.display.modelFrame) then return; end
    local f = private.display.modelFrame;
    local p, rf, rp, x, y = f:GetPoint();

    if (y > private.Y_POSITION) then
        f:SetPoint(p, rf, rp, x, y - 10) -- 10 is the step value
        tk.C_Timer.After(0.01, private.StartFalling);
    else
        if (y < private.Y_POSITION) then
            f:SetPoint(p, rf, rp, x, private.Y_POSITION);
            PositionModel(private.display.modelFrame.model, nil, true);
        end
        f.model:SetAnimation(39);
        f.model.dragging = nil;
    end
end

function private:StartRotating()
    if (not private.display.modelFrame) then return; end
    local f = private.display.modelFrame;
    if (f.model.dragging) then
        local scaledScreenWidth = tk.UIParent:GetWidth() * tk.UIParent:GetScale();
        local modelPoint = f:GetLeft() + ((f:GetWidth()) / 2);

        local rotation = (scaledScreenWidth - modelPoint) - (scaledScreenWidth * 0.5);
        f.model:SetFacing(rotation / 1000);

        local justify = private.display.name:GetJustifyH();
        if (modelPoint > (scaledScreenWidth * 0.5)) then
            if (justify == "RIGHT") then
                private.display.name:SetJustifyH("LEFT");
                private.display.name:ClearAllPoints();
                private.display.name:SetPoint("TOPLEFT", private.display, "TOPLEFT", 100, -14);
            end
        else
            if (justify == "LEFT") then
                private.display.name:SetJustifyH("RIGHT");
                private.display.name:ClearAllPoints();
                private.display.name:SetPoint("TOPRIGHT", -100, -14);
            end
        end
        tk.C_Timer.After(0.01, private.StartRotating);
    end
end

function private:CreatePlayerModel()
    local scale = db.global.afk.modelScale;
    private.Y_POSITION = 100;

    local f = tk.CreateFrame("Frame", nil, self.display);
    f:SetSize(200, 500 * scale);
    f:SetPoint("BOTTOMLEFT", self.display, "BOTTOMLEFT", 100, private.Y_POSITION)
    tk:MakeMovable(f);

    -- for testing:
    --tk:SetBackground(f, 0, 0, 0);

    f.model = tk.CreateFrame("PlayerModel", nil, f);
    f.model:SetSize(600 * scale, 700 * scale);
    f.model:SetUnit("player");
    f.model:SetFacing(0.4);

    f:SetScript("OnMouseUp", function(self)
        self.model:SetAnimation(8);
    end)

    f:SetScript("OnEnter", function()
        SetCursor("Interface\\CURSOR\\UI-Cursor-Move.blp");
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
        PositionModel(private.display.modelFrame.model, true);
        private:StartRotating();
    end)

    f:HookScript("OnDragStop", function(self)
        self:SetClampedToScreen(false) -- so it can fall lower off the screen
        local left = self:GetLeft()
        local bottom = self:GetBottom()
        self:ClearAllPoints()
        self:SetPoint("BOTTOMLEFT", private.display, "BOTTOMLEFT", left, bottom)
        private:StartFalling();
    end);
    return f;
end

do
    local function IncrementCounter(self)
        self.f.num = (self.f.num or 0) + 1;
        self.f:SetText(tk.string.format(self.f.label, self.f.num));
    end

    function private:CreateDisplay()
        if (self.display) then return self.display; end
        local f = tk.CreateFrame("Frame", "MUI_AFKFrame", WorldFrame);
        f:SetPoint("BOTTOMLEFT", tk.UIParent, "BOTTOMLEFT", 0, -100);
        f:SetPoint("BOTTOMRIGHT", tk.UIParent, "BOTTOMRIGHT", 0, -100);
        f:SetHeight(150);
        f.bg = tk:SetBackground(f, tk.Constants.MEDIA.."bottom_ui\\Single");
        tk:SetThemeColor(f.bg);

        tk.UIParent:HookScript("OnShow", function()
            afk:Toggle(false);
        end);

        f.time = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge");
        f.time:SetPoint("TOP", 0, -16);

        f.name = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        f.name:SetJustifyH("RIGHT");
        f.name:SetPoint("TOPRIGHT", -100, -14);

        local specType
        if (GetSpecialization()) then
            specType = (tk.select(2, GetSpecializationInfo(GetSpecialization()))).." ";
        else
            specType = "";
        end
        local name = tk.string.format("%s - %s\nLevel %u, "..tk:GetClassColoredString(nil, specType..UnitClass("player")),
            UnitPVPName("player"),
            GetRealmName(),
            UnitLevel("player")
        );
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

        f.dataFrame.left:SetText("Whispers: 0");
        f.dataFrame.right:SetText("Guild Chat: 0");
        f.dataFrame.right.label = "Guild Chat: %u";
        f.dataFrame.left.label = "Whispers: %u";

        em:CreateEventHandler("CHAT_MSG_WHISPER", IncrementCounter).f = f.dataFrame.left;
        em:CreateEventHandler("CHAT_MSG_BN_WHISPER", IncrementCounter).f = f.dataFrame.left;
        em:CreateEventHandler("CHAT_MSG_GUILD", IncrementCounter).f = f.dataFrame.right;
        return f;
    end
end

--------------------------
-- AFK functions:
--------------------------
function afk:Toggle(show)
    if (tk.InCombatLockdown() or (AuctionFrame and AuctionFrame:IsVisible())) then
        if (private.display) then
            private.display:Hide();
        end
        return;
    end
    if (show) then
        tk.UIParent:Hide();
        MoveViewLeftStart(0.01);
        if (not private.display) then
            private.display = private:CreateDisplay();
            if (db.global.afk.playerModel) then
                private.display.modelFrame = private:CreatePlayerModel();
            end
        end
        private.display:Show();
        PositionModel(private.display.modelFrame.model);
        private:ResetDataText();
        private:StartTimer();
    else
        tk.UIParent:Show();
        if (db.global.afk.rotateCamera) then
            MoveViewLeftStop();
            SetCVar("cameraView", "0"); -- to remove bug
        end
        if (private.display) then
            private.display:Hide();
        end
    end
end

function afk:SetEnabled(enable)
    if (enable and not afk.handler) then
        afk.handler = em:CreateEventHandler("PLAYER_FLAGS_CHANGED", function(self, _, unitID)
            if (unitID ~= "player") then return; end
            if (not db.global.afk.enabled) then return; end
            afk:Toggle(UnitIsAFK(unitID));
        end);
        em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
            afk:Toggle(false);
        end);
    end
end

function afk:init()
    if (not MayronUI:IsInstalled()) then return; end
    self:SetEnabled(db.global.afk.enabled);
end