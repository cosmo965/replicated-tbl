--[[
    Author: (Cosmo 01-28-24)
    
    Service for ReplicatedTbl
    Similar to ReplicaService without being verbose
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = require(script.Parent.Shared)

export type ReplicatedTblType = {
    TableName: string,
    Table: {},
    ReplicateTarget: Player | "All"
}

local Service = {}

local ReplicateRemote = Instance.new("RemoteEvent")
ReplicateRemote.Name = Shared.RemoteName
ReplicateRemote.Parent = Shared.RemoteParent

-- Replicator Object
local ReplicatedTbl = {}
Service.ReplicatedTblClass = ReplicatedTbl
ReplicatedTbl.__index = ReplicatedTbl

local function replicateTable(self, action: string, ...)
    if self._replicateTarget == "All" then
        ReplicateRemote:FireAllClients(action, ...)
    elseif self._replicateTarget:IsA("Player") then
        ReplicateRemote:FireClient(self._replicateTarget, action, ...)
    end
end
--[[
    Creates a new replicator
    Create a replicator for a player or for everyone
    Replicators send tabl

    @param params   ReplicatorParams    params for replicator
]]
function ReplicatedTbl.new(params: ReplicatedTblType)
    local self = {}

    self.TableName = params.TableName
    self.Data = params.Table
    self._replicateTarget = params.ReplicateTarget
    
    replicateTable(self, "create", self.TableName, self.Data)
    print('replicated table for data created')
    return setmetatable(self, ReplicatedTbl)
end

function ReplicatedTbl:ChangeData(path: string, newValue: any)
    Shared.writeNested(self.Data, path, newValue)
    replicateTable(self, "change", self.TableName, path, newValue)
    print('replicated table for data changed')
end

function ReplicatedTbl:Destroy()

end

-- Service functions

return Service