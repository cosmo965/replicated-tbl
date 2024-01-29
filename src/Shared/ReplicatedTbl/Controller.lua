--[[
    Author: (Cosmo 01-28-24)
    
    Controller for ReplicatedTbl
    Receives all the tables which is being sent by replicators on the server
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = require(script.Parent.Shared)

local ReplicateRemote = Shared.RemoteParent:WaitForChild(Shared.RemoteName, 5)

local Controller = {}
Controller._tables = {}
Controller._isActive = false
Controller._tableCreatedSignal = Shared.GoodSignal.new()

function Controller:RequestTables()
    if Controller._isActive then return end

    ReplicateRemote.OnClientEvent:Connect(function(action, ...)
        if action == "create" then
            local tblName, tbl = ...
            Controller._tables[tblName] = {
                _changedSignal = Shared.GoodSignal.new(),
                _table = tbl
            }
            Controller._tableCreatedSignal:Fire(tblName, tbl)
        elseif action == "change" then
            local tblName, path, newValue = ...
            local tblProfile = Controller._tables[tblName]
            local oldValue = Shared.readNested(tblProfile._table, path)

            Shared.writeNested(tblProfile._table, path, newValue)
            tblProfile._changedSignal:Fire(newValue, oldValue)
        end
    end)
    print('finished loading replicated table request')
    Controller._isActive = true
end

function Controller:GetTableChangedListener(tblName: string)
    if not Controller._isActive then return end

    local tblProfile = Controller._tables[tblName]

    return tblProfile._changedSignal
end

function Controller:GetTableCreatedListener()
    if not Controller._isActive then return end

    return Controller._tableCreatedSignal
end

--[[
    Returns immutable table
]]
function Controller:GetTable(tblName: string)
    if not Controller._isActive or not Controller._tables[tblName] then return end
    
    return table.freeze(Controller._tables[tblName]._table) or nil
end

return Controller