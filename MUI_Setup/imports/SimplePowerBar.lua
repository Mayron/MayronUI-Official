local _, setup = ...;

setup.import["SimplePowerBar"] = function()
    local settings = {
        ["Default"] = {
            ["label"] = false,
            ["LabelText"] = {
                ["colorClass"] = true,
                ["ofy"] = -34,
                ["style"] = "OUTLINE",
                ["size"] = 11,
            },
            ["width"] = 215,
            ["y"] = -100,
            ["x"] = 0,
            ["height"] = 20,
            ["locked"] = true,
            ["StatusBarText"] = {
                ["size"] = 11,
            },
            ["BackgroundColor"] = {
                ["a"] = 1,
                ["b"] = 0.06274509803921569,
                ["g"] = 0.06274509803921569,
                ["r"] = 0.06274509803921569,
            },
            ["anchor"] = "TOP",
        },
    };
    for k, v in pairs(settings) do
        SimpPB_DB.profiles[k] = v;
    end
end