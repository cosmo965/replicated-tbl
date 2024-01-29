local ReplicatedStorage =  game:GetService("ReplicatedStorage")

local Shared = {
    RemoteName = "replicatedTbl_replicator",
    RemoteParent = ReplicatedStorage
}
Shared.GoodSignal = require(script.Parent.GoodSignal)

function Shared.writeNested(tabl: {}, path: string, newValue: any)
    local pathSplit = string.split(path, ".")
    while #pathSplit > 1 do
        local index = table.remove(pathSplit, 1)
        if not tabl[index] then tabl[index] = {} end
        tabl = tabl[index]
    end
    tabl[pathSplit[1]] = newValue
end

function Shared.readNested(tabl: {}, path: string)
    return nil
end

function Shared.RetryTill(condition: () -> boolean, maxTries: number)
    maxTries = maxTries or 10
    
    if condition() then
        return true
    end

    local tries = 0
    while tries < maxTries do
        if condition() then
            break
        end
        task.wait()
    end
    if tries >= maxTries then
        return false
    else
        return true
    end
end

return Shared