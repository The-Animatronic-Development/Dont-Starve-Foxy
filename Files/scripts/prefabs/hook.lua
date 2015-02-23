local assets=
{
    Asset("ANIM", "anim/hook.zip"),
    Asset("ANIM", "anim/swap_hook.zip"),
 
    Asset("ATLAS", "images/inventoryimages/hook.xml"),
    Asset("IMAGE", "images/inventoryimages/hook.tex"),
}

local prefabs = 
{
}

local function fn()
 
    local function OnEquip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "swap_hook", "swap_hook")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end
 
    local function OnUnequip(inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
    end
 
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
     
    anim:SetBank("hook")
    anim:SetBuild("hook")
    anim:PlayAnimation("idle")
 
    inst:AddComponent("inspectable")
    
	inst:AddTag("sharp")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(52)
	
	inst:AddComponent("characterspecific")
    inst.components.characterspecific:SetOwner("foxy")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "hook"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hook.xml"
     
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
 
    return inst
end
return  Prefab("common/inventory/hook", fn, assets, prefabs)