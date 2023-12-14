local QBCore = exports["qb-core"]:GetCoreObject()

QBCore.Functions.CreateUseableItem(Config.Item, function(source)
  TriggerClientEvent("giga-hotwire:client:Hotwire", source)
  if not Config.Consume.Enabled then return end

  local Player = QBCore.Functions.GetPlayer(source)
  Player.Functions.RemoveItem(Config.Item, 1)
end)
