local ReplicatedStorage =  game:GetService("ReplicatedStorage")

local Shared = {
    RemoteName = "replicatedTbl_replicator",
    RemoteParent = ReplicatedStorage
}
Shared.GoodSignal = require(ReplicatedStorage:FindFirstChild("Packages"):FindFirstChild("GoodSignal")) or require(script.Parent.GoodSignal)

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

return Shared