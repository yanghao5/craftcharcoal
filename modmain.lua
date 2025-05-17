PrefabFiles = {
    "charcoalmaker",
}

Assets = {
    Asset("ATLAS", "images/inventoryimages/charcoalmaker.xml"),
    Asset("IMAGE", "images/inventoryimages/charcoalmaker.tex"),
    Asset("IMAGE", "minimap/minimap_charcoalmaker.tex"),
    Asset("ATLAS", "minimap/minimap_charcoalmaker.xml"),
}

AddMinimapAtlas("minimap/minimap_charcoalmaker.xml")

local STRINGS = GLOBAL.STRINGS
local TECH = GLOBAL.TECH

--Config
TUNING.CHARCOALMAKER_FUEL_MAX = GetModConfigData("config_fuel_max")
TUNING.CHARCOALMAKER_SPAWN_TIME = GetModConfigData("config_spawn_time")

STRINGS.CHARCOALMAKER = "Coal Maker"
STRINGS.NAMES.CHARCOALMAKER = "Coal Maker"
STRINGS.RECIPE_DESC.CHARCOALMAKER = "Coal,Oh,Black Coal!"

--addRecipe
local ingreditents

if GetModConfigData("config_recipe") == 1 then
    ingreditents = {
        Ingredient("heatrock", 1),
        Ingredient("log", 5),
        Ingredient("rocks", 10),
    }
elseif GetModConfigData("config_recipe") == 2 then
    ingreditents = {
        Ingredient("heatrock", 1),
        Ingredient("boards", 3),
        Ingredient("gears", 1),
    }
end

AddRecipe2(
    "charcoalmaker",
    ingreditents,
    TECH.SCIENCE_TWO,
    {
        atlas = "images/inventoryimages/charcoalmaker.xml",
        image = "charcoalmaker.tex",
        placer = "charcoalmaker_placer",
    },
    { "SCIENCE" }
)
