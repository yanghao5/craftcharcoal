require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/coalmachine.zip"),
}

local prefabs =
{
    "collapse_small",
    "charcoal",
}

local MACHINESTATES =
{
    ON = "_on",
    OFF = "_off",
}

local function spawncoal(inst)
    inst:RemoveEventCallback("animover", spawncoal)

    local charcoal = SpawnPrefab("charcoal")
    local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(0,2,0)
    charcoal.Transform:SetPosition(pt:Get())
    local down = TheCamera:GetDownVec()
    local angle = math.atan2(down.z, down.x) + (math.random()*6)*DEGREES
    local sp = 3 + math.random()
    charcoal.Physics:SetVel(sp*math.cos(angle), math.random()*2+8, sp*math.sin(angle))
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())

    --Machine should only ever be on after spawning an coal
    inst.components.fueled:StartConsuming()
    inst.AnimState:PlayAnimation("working_loop")
	inst.AnimState:PushAnimation("working_loop", true)
end

local function onhammered(inst, worked)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")

    inst:Remove()
end

local function fueltaskfn(inst)
    inst.AnimState:PlayAnimation("on")
    inst.components.fueled:StopConsuming() --temp pause fuel so we don't run out in the animation.
    inst:ListenForEvent("animover", spawncoal)
end
--添加燃料
local function ontakefuelfn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
    inst.components.fueled:StartConsuming()
end

local function fuelsectioncallback(new, old, inst)
    if new == 0 and old > 0 then
        inst.machinestate = MACHINESTATES.OFF
        inst.AnimState:PlayAnimation("off")
        inst.AnimState:PushAnimation("off", true)
        inst.SoundEmitter:KillSound("loop")
        if inst.fueltask ~= nil then
            inst.fueltask:Cancel()
            inst.fueltask = nil
        end
    elseif new > 0 and old == 0 then
        inst.machinestate = MACHINESTATES.ON
        inst.AnimState:PlayAnimation("working_loop")
        inst.AnimState:PushAnimation("working_loop", true)
        if not inst.SoundEmitter:PlayingSound("loop") then
            --inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/icemachine_lp", "loop")
        end
        if inst.fueltask == nil then
            inst.fueltask = inst:DoPeriodicTask(TUNING.CHARCOALMAKER_SPAWN_TIME, fueltaskfn)
        end
    end
end

local function getstatus(inst)
    local sec = inst.components.fueled:GetCurrentSection()
    if sec == 0 then
        STRINGS.CHARACTERS.GENERIC.DESCRIBE.CHARCOALMAKER            = "It needs more fuel."
        STRINGS.CHARACTERS.WILLOW.DESCRIBE.CHARCOALMAKER             = "It turns fire into coal. Boo."
        STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.CHARCOALMAKER           = "Small machine is out of juice."
        STRINGS.CHARACTERS.WENDY.DESCRIBE.CHARCOALMAKER              = "My heart makes fire too."
        STRINGS.CHARACTERS.WX78.DESCRIBE.CHARCOALMAKER               = "FUEL IS DEPLETED"
        STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.CHARCOALMAKER       = "It's out of energy."
        STRINGS.CHARACTERS.WOODIE.DESCRIBE.CHARCOALMAKER             = "It's hooped."
        STRINGS.CHARACTERS.WAXWELL.DESCRIBE.CHARCOALMAKER            = "It's not doing its job."
        STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.CHARCOALMAKER         = "Reminds me öf höme."
        STRINGS.CHARACTERS.WEBBER.DESCRIBE.CHARCOALMAKER             = "coal is useful in many places."
        return "OUT"
    elseif sec == 1 then
        STRINGS.CHARACTERS.GENERIC.DESCRIBE.CHARCOALMAKER            = "I can hear it sputtering."
        STRINGS.CHARACTERS.WILLOW.DESCRIBE.CHARCOALMAKER             = "It turns fire into coal. Boo."
        STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.CHARCOALMAKER           = "Machine will not last much longer."
        STRINGS.CHARACTERS.WENDY.DESCRIBE.CHARCOALMAKER              = "My heart makes fire too."
        STRINGS.CHARACTERS.WX78.DESCRIBE.CHARCOALMAKER               = "MACHINE IS RUNNING ON EMPTY"
        STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.CHARCOALMAKER       = "Nearly empty."
        STRINGS.CHARACTERS.WOODIE.DESCRIBE.CHARCOALMAKER             = "It'll give out any second."
        STRINGS.CHARACTERS.WAXWELL.DESCRIBE.CHARCOALMAKER            = "It's on its last legs."
        STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.CHARCOALMAKER         = "Reminds me öf höme."
        STRINGS.CHARACTERS.WEBBER.DESCRIBE.CHARCOALMAKER             = "coal is useful in many places."
        return "VERYLOW"
    elseif sec == 2 then
        STRINGS.CHARACTERS.GENERIC.DESCRIBE.CHARCOALMAKER            = "It seems to be slowing down."
        STRINGS.CHARACTERS.WILLOW.DESCRIBE.CHARCOALMAKER             = "It turns fire into coal. Boo."
        STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.CHARCOALMAKER           = "Little machine looks tired"
        STRINGS.CHARACTERS.WENDY.DESCRIBE.CHARCOALMAKER              = "My heart makes fire too."
        STRINGS.CHARACTERS.WX78.DESCRIBE.CHARCOALMAKER               = "FUEL IS REQUIRED FOR FURTHER PRODUCTION"
        STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.CHARCOALMAKER       = "Its pace is dropping."
        STRINGS.CHARACTERS.WOODIE.DESCRIBE.CHARCOALMAKER             = "Gettin' low."
        STRINGS.CHARACTERS.WAXWELL.DESCRIBE.CHARCOALMAKER            = "I'd better fill it up."
        STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.CHARCOALMAKER         = "Reminds me öf höme."
        STRINGS.CHARACTERS.WEBBER.DESCRIBE.CHARCOALMAKER             = "coal is useful in many places."
        return "LOW"
    elseif sec == 3 then
        STRINGS.CHARACTERS.GENERIC.DESCRIBE.CHARCOALMAKER            = "It's putting along."
        STRINGS.CHARACTERS.WILLOW.DESCRIBE.CHARCOALMAKER             = "It turns fire into coal. Boo."
        STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.CHARCOALMAKER           = "Thank you for good coal, machine"
        STRINGS.CHARACTERS.WENDY.DESCRIBE.CHARCOALMAKER              = "My heart makes fire too."
        STRINGS.CHARACTERS.WX78.DESCRIBE.CHARCOALMAKER               = "MACHINE IS OPERATING SATISFACTORILY"
        STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.CHARCOALMAKER       = "The output is quite regular."
        STRINGS.CHARACTERS.WOODIE.DESCRIBE.CHARCOALMAKER             = "It's pumping along nicely."
        STRINGS.CHARACTERS.WAXWELL.DESCRIBE.CHARCOALMAKER            = "It appears to be doing its job."
        STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.CHARCOALMAKER         = "Reminds me öf höme."
        STRINGS.CHARACTERS.WEBBER.DESCRIBE.CHARCOALMAKER             = "coal is useful in many places."
        return "NORMAL"
    elseif sec == 4 then
        STRINGS.CHARACTERS.GENERIC.DESCRIBE.CHARCOALMAKER            = "It's running great!"
        STRINGS.CHARACTERS.WILLOW.DESCRIBE.CHARCOALMAKER             = "It turns fire into coal. Boo."
        STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.CHARCOALMAKER           = "Machine is doing very good job!"
        STRINGS.CHARACTERS.WENDY.DESCRIBE.CHARCOALMAKER              = "My heart makes fire too."
        STRINGS.CHARACTERS.WX78.DESCRIBE.CHARCOALMAKER               = "MACHINE IS OPERATING AT OPTIMAL LEVEL"
        STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.CHARCOALMAKER       = "coaltastic!"
        STRINGS.CHARACTERS.WOODIE.DESCRIBE.CHARCOALMAKER             = "Furiously icy! Reminds me of home."
        STRINGS.CHARACTERS.WAXWELL.DESCRIBE.CHARCOALMAKER            = "It's working hard to make coal for me."
        STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.CHARCOALMAKER         = "Reminds me öf höme."
        STRINGS.CHARACTERS.WEBBER.DESCRIBE.CHARCOALMAKER             = "coal is useful in many places."
        return "HIGH"
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("working_loop")
    inst.AnimState:PushAnimation("working_loop",true)
    inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_place")
end

local function onFloodedStart(inst)
    if inst.components.fueled then 
        inst.components.fueled.accepting = false
    end 
end 

local function onFloodedEnd(inst)
    if inst.components.fueled then 
        inst.components.fueled.accepting = true
    end 
end 

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

    local minimap = inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("minimap_charcoalmaker.tex")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    inst.AnimState:SetBank("coalmachine")
    inst.AnimState:SetBuild("coalmachine")

    inst:AddTag("structure")

    inst:AddComponent("lootdropper")

    inst:AddComponent("fueled")
    inst.components.fueled.maxfuel = TUNING.CHARCOALMAKER_FUEL_MAX
    inst.components.fueled.accepting = true
    inst.components.fueled:SetSections(4)
    inst.components.fueled.ontakefuelfn = ontakefuelfn
    --inst.components.fueled:SetUpdateFn(fuelupdatefn)
    inst.components.fueled:SetSectionCallback(fuelsectioncallback)
    inst.components.fueled:InitializeFuelLevel(0)
    inst.components.fueled:StartConsuming()
    local oldCanAcceptFuelItem = inst.components.fueled.CanAcceptFuelItem
    inst.components.fueled.CanAcceptFuelItem = function(self, item)
        if item.prefab == "charcoal" then
            return false
        end
        return oldCanAcceptFuelItem(self, item)
    end

    inst:AddComponent("inspectable")
	--对话
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    --inst.components.workable:SetOnWorkCallback(onhit)

    MakeLargeBurnable(inst, nil, nil, true)
    MakeLargePropagator(inst)

    inst.machinestate = MACHINESTATES.ON
    inst:ListenForEvent( "onbuilt", onbuilt)

    return inst
end

return Prefab( "common/charcoalmaker", fn, assets, prefabs),
MakePlacer( "common/charcoalmaker_placer", "coalmachine", "coalmachine", "on" )
