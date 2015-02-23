PrefabFiles = {
	"foxy",
	"hook",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/foxy.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/foxy.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/foxy.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/foxy.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/foxy_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/foxy_silho.xml" ),

    Asset( "IMAGE", "bigportraits/foxy.tex" ),
    Asset( "ATLAS", "bigportraits/foxy.xml" ),
	
	Asset( "IMAGE", "images/map_icons/foxy.tex" ),
	Asset( "ATLAS", "images/map_icons/foxy.xml" ),

	Asset("ATLAS", "images/inventoryimages/houndmound.xml"),
	Asset("IMAGE", "images/inventoryimages/houndmound.tex"),
}

GetPlayer = GLOBAL.GetPlayer
GetWorld = GLOBAL.GetWorld
ACTIONS = GLOBAL.ACTIONS

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.foxy = "The Red Fox"
STRINGS.CHARACTER_NAMES.foxy = "foxy"
STRINGS.CHARACTER_DESCRIPTIONS.foxy = "*The Animatronic Fox\n*Good at escaping\n*Vegetables? No, I Dont Eat."
STRINGS.CHARACTER_QUOTES.foxy = "\"People I Scare Them\""

-- Custom speech strings
STRINGS.CHARACTERS.foxy = require "speech_foxy"

-- Custom items
STRINGS.NAMES.hook = "Foxy's Hook"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.hook = "A Dangerous Looking Hook"

-- Let the game know character is male, female, or robot
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "foxy")

-- Function to make beefalo hostile to character
local makeBeefaloHostile = function (prefab)
    if prefab.components.combat then
        local targetfn_orig = prefab.components.combat.targetfn
        local targetfn_new = function(inst)
            local target = nil
            -- First retarget normally
            if targetfn_orig then target = targetfn_orig(inst) end
            -- If no target found, target foxy
            if target == nil then
                target = GLOBAL.FindEntity(inst, GLOBAL.TUNING.BEEFALO_TARGET_DIST, function(guy)
                    return not guy:HasTag("beefalo") and
                            inst.components.combat:CanTarget(guy) and
                            not guy:HasTag("wall")
                            and guy.prefab == "foxy"
                end)
            end
            return target
        end
        prefab.components.combat.targetfn = targetfn_new
    end
end
 
AddPrefabPostInit("beefalo", makeBeefaloHostile)
AddMinimapAtlas("images/map_icons/foxy.xml")
AddModCharacter("foxy")

