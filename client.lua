local QBCore = exports["qb-core"]:GetCoreObject()
local Util = exports["giga-util"]:GetUtils()

local function Debugger(identifier)
  return Util.Debugger(GetCurrentResourceName() .. ":client:" .. identifier)
end

local function IsVehicleExempt(vehicle)
  if not #Config.Exempt.Classes then return false end
  local vehicleClass = GetVehicleClass(vehicle)
  for _, exemptVehicleClass in ipairs(Config.Exempt.Classes) do
    if vehicleClass == exemptVehicleClass then return true end
  end
  return false
end

local function IsVehicleABike(vehicle)
  local vehicleClass = GetVehicleClass(vehicle)
  return vehicleClass == 8 or vehicleClass == 13
end

RegisterNetEvent("giga-hotwire:client:Hotwire", function()
  local debug = Debugger("event:Hotwire")
  local ped = PlayerPedId()
  if not ped then return end
  if not IsPedInAnyVehicle(ped, false) then
    return QBCore.Functions.Notify(
      "You are not in a vehicle!", "error")
  end
  local vehicle = GetVehiclePedIsIn(ped, false)
  debug({ vehicle = vehicle, })
  if not DoesEntityExist(vehicle) then
    return QBCore.Functions.Notify(
      "Invalid vehicle!", "error")
  end
  if GetPedInVehicleSeat(vehicle, -1) ~= ped then
    return QBCore.Functions.Notify(
      "You must be in the driver's seat!", "error")
  end
  if GetIsVehicleEngineRunning(vehicle) then
    return QBCore.Functions.Notify(
      "Vehicle is already running!", "error")
  end

  if IsVehicleExempt(vehicle) then
    return QBCore.Functions.Notify(
      "You cannot lockpick this vehicle!", "error")
  end

  debug("attempting to hotwire")

  local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
  local anim = "machinic_loop_mechandplayer"
  local isABike = IsVehicleABike(vehicle)
  local duration = Util.Chance.Range(Config.Duration.Minimum, Config.Duration.Maximum)
  if isABike then duration = duration * 2 end
  exports["progressbar"]:Progress({
    name = "hotwire",
    duration = duration,
    label = "Attempting to lockpick...",
    useWhileDead = false,
    canCancel = true,
    controlDisables = {
      disableMovement = true,
      disableCarMovement = true,
      disableMouse = false,
      disableCombat = true,
    },
    animation = {
      animDict = animDict,
      anim = anim,
      flags = 17,
    },
  }, function(cancelled)
    ClearPedTasks(ped)
    if cancelled then return end
    if not Util.Chance.Boolean(Config.Probability.Success) then
      return QBCore.Functions.Notify("Failed to lockpick!",
        "error")
    end
    SetVehicleEngineOn(vehicle, true, false, true)
    QBCore.Functions.Notify("You lockpicked the vehicle!", "success")
  end)

  local shouldAlert
  shouldAlert = Config.Alert.Enabled == true and Util.Chance.Boolean(Config.Probability.Alert) or false
  if not shouldAlert and isABike and Config.Alert.Enabled == "bike" then
    shouldAlert = Util.Chance.Boolean(Config
      .Probability.Alert)
  end
  debug({ shouldAlert = shouldAlert, })
  if not shouldAlert then return end
  debug("reporting crime...")
  exports["ps-dispatch"]:VehicleTheft(vehicle)
end)
