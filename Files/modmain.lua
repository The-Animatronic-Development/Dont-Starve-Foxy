PrefabFiles = {
	"wakkari",
	"bellstaff",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/wakkari.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/wakkari.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/wakkari.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/wakkari.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/wakkari_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/wakkari_silho.xml" ),

    Asset( "IMAGE", "bigportraits/wakkari.tex" ),
    Asset( "ATLAS", "bigportraits/wakkari.xml" ),
	
	Asset( "IMAGE", "images/map_icons/wakkari.tex" ),
	Asset( "ATLAS", "images/map_icons/wakkari.xml" ),

	Asset("ATLAS", "images/inventoryimages/houndmound.xml"),
	Asset("IMAGE", "images/inventoryimages/houndmound.tex"),
}

GetPlayer = GLOBAL.GetPlayer
GetWorld = GLOBAL.GetWorld
ACTIONS = GLOBAL.ACTIONS

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.wakkari = "The Red Fox"
STRINGS.CHARACTER_NAMES.wakkari = "Wakkari"
STRINGS.CHARACTER_DESCRIPTIONS.wakkari = "*Sly cousin of hounds\n*Good at escaping\n*Vegetables? No, thank you."
STRINGS.CHARACTER_QUOTES.wakkari = "\"Fur and horns? I don't adore them...\""

-- Custom speech strings
STRINGS.CHARACTERS.WAKKARI = require "speech_wakkari"

-- Custom items
STRINGS.NAMES.BELLSTAFF = "Fox Tribe Bell Staff"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BELLSTAFF = "Tricky looking staff with bells."

-- Let the game know character is male, female, or robot
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "wakkari")

-- Function to make beefalo hostile to character
local makeBeefaloHostile = function (prefab)
    if prefab.components.combat then
        local targetfn_orig = prefab.components.combat.targetfn
        local targetfn_new = function(inst)
            local target = nil
            -- First retarget normally
            if targetfn_orig then target = targetfn_orig(inst) end
            -- If no target found, target Wakkari
            if target == nil then
                target = GLOBAL.FindEntity(inst, GLOBAL.TUNING.BEEFALO_TARGET_DIST, function(guy)
                    return not guy:HasTag("beefalo") and
                            inst.components.combat:CanTarget(guy) and
                            not guy:HasTag("wall")
                            and guy.prefab == "wakkari"
                end)
            end
            return target
        end
        prefab.components.combat.targetfn = targetfn_new
    end
end
 
AddPrefabPostInit("beefalo", makeBeefaloHostile)
AddMinimapAtlas("images/map_icons/wakkari.xml")
AddModCharacter("wakkari")

