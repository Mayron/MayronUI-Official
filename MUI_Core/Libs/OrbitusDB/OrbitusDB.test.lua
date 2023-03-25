function Mixin(object, ...)
	for i = 1, select("#", ...) do
		local mixin = select(i, ...);
		for k, v in pairs(mixin) do
			object[k] = v;
		end
	end

	return object;
end

function CreateFromMixins(...)
	return Mixin({}, ...);
end

function CreateAndInitFromMixin(mixin, ...)
	local object = CreateFromMixins(mixin);
	object:Init(...);
	return object;
end


function strsplit(delimiter, str)
  local t = {}

  for s in string.gmatch(str, "[^" .. delimiter .. "]+") do
    table.insert(t, s)
  end

  return t;
end

string.split = strsplit;

function UnitFullName()
  return "Mayron-Gehennas";
end

local OrbitusDB = require("MUI_Core/Libs/OrbitusDB/OrbitusDB");

---@type DatabaseConfig
local databaseConfig = {
  defaults = {
    profile = {
      colors = {
        timeRemaining = {1, 1, 1};
        count         = {1, 0.82, 0};
        auraName      = {1, 1, 1};
        statusbarBorder = {0, 0, 0};
        helpful        = {0.2, 0.2, 0.2};
        harmful        = {0.76, 0.2, 0.2};
        magic         = {0.2, 0.6, 1};
        disease       = {0.6, 0.4, 0};
        poison        = {0.0, 0.6, 0};
        curse         = {0.6, 0.0, 1};
        background   = { 0, 0, 0, 0.6 };
        foreground   = { 0.15, 0.15, 0.15 };
        owned        = { 0.15, 0.15, 0.15 };
      },

      buffs = {
        mode = "icons";

        icons = {
          pulse = false;
          nonPlayerAlpha = 0.7;
          vDirection = "DOWN";
          hDirection = "LEFT";
          iconWidth = 40;
          iconHeight = 30;
          iconBorderSize = 2;
          xSpacing = 6;
          ySpacing = 20;
          perRow = 10;
          iconShadow = true;
          secondsWarning = 10;
          position = { "TOPRIGHT", "UIParent", "TOPRIGHT", -5, -5 };
          textSize = {
            timeRemaining = 10;
            timeRemainingLarge = 14;
            count = 14;
          };
          textPosition = {
            timeRemaining = { "TOP", "iconFrame", "BOTTOM", 0, -4 };
            count         = { "BOTTOMRIGHT", "icon", "BOTTOMRIGHT", 0, 2 };
          };
        };

        statusbars = {
          pulse = false;
          nonPlayerAlpha = 1;
          vDirection = "DOWN";
          hDirection = "LEFT";
          iconWidth = 22;
          iconHeight = 20;
          iconBorderSize = 1;
          barWidth = 200;
          barHeight = 22;
          xSpacing = 4;
          ySpacing = 1;
          iconSpacing = 2;
          iconShadow = false;
          perRow = 1;
          secondsWarning = 10;
          texture = "MUI_StatusBar";
          showSpark = true;

          position = { "TOPRIGHT", "UIParent", "TOPRIGHT", -3, -3 };
          textSize = {
            timeRemaining = 10;
            timeRemainingLarge = 14;
            count = 14;
            auraName = 10;
          };

          textPosition = {
            timeRemaining = { "RIGHT", "bar", -4, 0 };
            count         = { "RIGHT", "icon", "LEFT", -4, 0 };
            auraName      = { "LEFT", "bar", "LEFT", 4, 0 };
          };
        }
      };

      debuffs = {
        mode = "icons";

        icons = {
          pulse = false;
          nonPlayerAlpha = 0.7;
          vDirection = "DOWN";
          hDirection = "LEFT";
          iconWidth = 40;
          iconHeight = 30;
          iconBorderSize = 1;
          xSpacing = 6;
          ySpacing = 20;
          perRow = 10;
          iconShadow = true;
          secondsWarning = 10;
          position = { "TOPRIGHT", "MUI_BuffFrames", "BOTTOMRIGHT", 0, -40 };
          textSize = {
            timeRemaining = 10;
            timeRemainingLarge = 14;
            count = 14;
          };
          textPosition = {
            timeRemaining = { "TOP", "iconFrame", "BOTTOM", 0, -4 };
            count         = { "BOTTOMRIGHT", "icon", "BOTTOMRIGHT", 0, 2 };
          };
        };

        statusbars = {
          pulse = false;
          nonPlayerAlpha = 0.7;
          vDirection = "DOWN";
          hDirection = "LEFT";
          iconWidth = 40;
          iconHeight = 30;
          iconBorderSize = 1;
          barWidth = 200;
          barHeight = 22;
          xSpacing = 4;
          ySpacing = 1;
          iconSpacing = 1;
          iconShadow = false;
          perRow = 1;
          secondsWarning = 10;
          position = { "TOPRIGHT", "MUI_BuffFrames", "BOTTOMRIGHT", 0, -40 };
          texture = "MUI_StatusBar";
          showSpark = true;

          textSize = {
            timeRemaining = 10;
            timeRemainingLarge = 14;
            count = 14;
            auraName = 10;
          };

          textPosition = {
            timeRemaining = { "RIGHT", "bar", -4, 0 };
            count         = { "BOTTOMRIGHT", "icon", "BOTTOMRIGHT", 0, 2 };
            auraName      = { "LEFT", "bar", "LEFT", 4, 0 };
          };
        }
      }
    }
  };
};

_G["MUI_AurasDB"] = {};

OrbitusDB:Register("MUI_AurasDB", databaseConfig, function (db)
  db.profile:Subscribe("something", function(a, b, c)
    print("from something: ", a, b, c);
  end);

  db.profile:Subscribe("something.hello.okay", function(a, b, c)
    print("from something.hello.okay: ", a, b, c);
  end);

  db.profile:Subscribe("something.hello.okay.chair", function(a, b, c)
    print("from something.hello.okay.chair: ", a, b, c);
  end);

  db.profile:Store("something['hello'].okay", 123);

  local result = db.profile:Query("something.hello.okay");
  assert(result == 123);

  db.profile:Store("something.hello.okay", {
    chair = 123;
  });

  result = db.profile:Query("something.hello.okay");
  assert(result == nil);

  result = db.profile:Query("something.hello.okay.chair");
  assert(result == 123);
end);