
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),
        Asset( "ANIM", "anim/beard.zip" ),

        Asset( "ANIM", "anim/foxy.zip" ),
}
local prefabs = {
"hook",
}

local start_inv = {
	-- Custom starting items
	"hook",
	"monstermeat",
	"monstermeat",
	"monstermeat",
	"monstermeat",
	"monstermeat",
}

local fn = function(inst)
	
	-- choose which sounds this character will play
	inst.soundsname = "willow"

	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "foxy.tex" )
	
	-- Stats	
	inst.components.health:SetMaxHealth(2000)
	inst.components.hunger:SetMax(1500)
	inst.components.sanity:SetMax(1700)
	inst.components.locomotor.walkspeed = (4)
	inst.components.locomotor.runspeed = (80)
	
	--Food
	local eater = inst.components.eater
	eater:SetCarnivore(true)
	eater.ignoresspoilage = true
	
	--custom recipe
	local houndmound_recipe = Recipe("houndmound", {Ingredient("houndstooth", 10), Ingredient("rocks", 25), Ingredient("beefalowool", 8)}, RECIPETABS.TOWN, TECH.NONE, "houndmound_placer")
	houndmound_recipe.sortkey = -8812222
	houndmound_recipe.atlas = resolvefilepath("images/inventoryimages/houndmound.xml")
	STRINGS.RECIPE_DESC.HOUNDMOUND = "Careful! Hounds may like this!"

	--Food penalty
	inst.components.eater.Eat_orig = inst.components.eater.Eat
function inst.components.eater:Eat( food )
	if self:CanEat(food) then
		if food.components.edible.sanityvalue < 0 then
		food.components.edible.sanityvalue = 1
	end
		if food.components.edible.healthvalue < 0 then
		food.components.edible.healthvalue = 3
	end
end
return inst.components.eater:Eat_orig(food)
end
	
	-- Disallow talking when saying an empty string
	local talker = inst.components.talker
	talker.Say_wakkari_redirect = talker.Say
	function talker:Say(script, time, noanim)
		if script == "" then return end
		talker:Say_wakkari_redirect(script, time, noanim)
	end
	
	--sanity from killing beefalos
 local function onkilled(victim,inst)
        if victim and victim.prefab then
        if victim.prefab == "beefalo" then
            inst.components.sanity:DoDelta(TUNING.SANITY_SMALL*0.5)
        end
        end
    end
 
    inst:ListenForEvent( "killed", function(inst,data) onkilled(data.victim,inst) end )
end

return MakePlayerCharacter("wakkari", prefabs, assets, fn, start_inv)
