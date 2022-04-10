-- TODO: save lock state on server
local block_modelName = 'prop_facgate_02_l'
local blocking_prop

local function load_model(modelName)
    if not HasModelLoaded(modelName) then
        RequestModel(modelName)
    
        while not HasModelLoaded(modelName) or not HasCollisionForModelLoaded(modelName) do
            Wait(1)
        end
    end
end

Citizen.CreateThread(function ()
    load_model(block_modelName)
    for i, gate in pairs(Gates) do
        load_model(gate.model)
        local gate_h = CreateObjectNoOffset(gate.model, gate.location.x, gate.location.y, gate.location.z, false, false, true)
        gate.entityId = gate_h
    
        SetEntityHeading(gate_h, gate.heading)
        SetEntityCollision(gate_h, true, false)

        SetEntityAsMissionEntity(gate_h, true, true)
        Wait(100)
        FreezeEntityPosition(gate_h, true)
    end

    blocking_prop = CreateObjectNoOffset(block_modelName, vector3(-667.8, -888.5, 26.631847), false, false, true)
    SetEntityCollision(blocking_prop, true, false)
    SetEntityHeading(blocking_prop, 269.78)
    SetCanClimbOnEntity(blocking_prop, false)
    SetEntityAsMissionEntity(blocking_prop, true, true)
    Wait(100)
    FreezeEntityPosition(blocking_prop, true)
    SetEntityCoords(blocking_prop, vector3(-667.8, -888.5, 23.631847), 0, 0, 0, false)

    -- if unlock - trigger togglegate
end)

-- NUI_doorlock (gateid) must have same name as configured here!!
AddEventHandler('gates:client:togglegate', function(gateid, isLocked)
    local entityId = Gates[gateid].entityId
    SetEntityCollision(entityId, isLocked, false)
    local coords = Gates[gateid].location
    local maxOffsetX = Gates[gateid].offset.x
    local maxOffsetY = Gates[gateid].offset.y
    local maxOffsetZ = Gates[gateid].offset.z
    local maxIter =  Gates[gateid].maxIter
    for i = 1, maxIter, 1 do
        if isLocked then
            if HasEntityCollidedWithAnything(entityId) then
                return
            end
            SetEntityCoords(entityId, (coords.x+maxIter*(maxOffsetX/maxIter)) - (i*(maxOffsetX/maxIter)), (coords.y+maxIter*(maxOffsetY/maxIter)) - (i*(maxOffsetY/maxIter)), (coords.z+maxIter*(maxOffsetZ/maxIter)) - (i*(maxOffsetZ/maxIter)), false, false, false, false)
        else
            SetEntityCoords(entityId, coords.x + (i*(maxOffsetX/maxIter)), coords.y + (i*(maxOffsetY/maxIter)), coords.z + (i*(maxOffsetZ/maxIter)), false, false, false, false)
        end
        Wait(0)
    end
end)

AddEventHandler('onResourceStop', function(name)
    if name == GetCurrentResourceName() then
        for _, gate in pairs(Gates) do
            local entityId = gate.entityId
            if entityId and DoesEntityExist(entityId) then
                DeleteEntity(entityId)
            end
        end
        if blocking_prop and DoesEntityExist(blocking_prop) then
            DeleteEntity(blocking_prop)
        end
    end
end)