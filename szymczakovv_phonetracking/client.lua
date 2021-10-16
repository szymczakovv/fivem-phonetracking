ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('szymczakovv:phoneTrackedSuccesfully')
AddEventHandler('szymczakovv:phoneTrackedSuccesfully', function(data)
  local getted = {
    firstname = data.first,
    lastname = data.second
  }
  local pos_encoded = json.encode(data.third)
  local pos_decoded = json.decode(pos_encoded)
  streetName,_ = GetStreetNameAtCoord(pos_decoded.x, pos_decoded.y, pos_decoded.z)
  streetName = GetStreetNameFromHashKey(streetName)
  TriggerEvent('esx:showAdvancedNotification', getted.firstname..' - '..getted.lastname, streetName)
  ShowPlayerBlip(pos_decoded.x, pos_decoded.y, pos_decoded.z)
end)

ShowPlayerBlip = function(a,b,c)
  local blip = AddBlipForCoord(a,b,c)
  SetBlipSprite(blip, 161)
  SetBlipScale(blip, 1.0)
  SetBlipColour(blip, 75)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString('#Namierzenie - Ostatnia zarejestrowana lokalizacja')
  EndTextCommandSetBlipName(blip)
  Wait(30000)
  RemoveBlip(blip)
end

ChangeData = function()
  ESX.UI.Menu.Open(
      'dialog', GetCurrentResourceName(), '.',
      {
        title = "Wpisz Numer"
      },
      function(data, menu)
          if data.value  == nil then
              TriggerEvent('esx:showNotification', 'Tekst nie może być pusty!')
          else
              menu.close()
              TriggerServerEvent('szymczakovv:TrackPhone', data.value)
          end
      end,
  function(data, menu)
      menu.close()
  end)
end

RegisterNetEvent('szymczakovv:showTracking')
AddEventHandler('szymczakovv:showTracking', function()
	ChangeData()
end)
