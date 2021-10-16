ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('szymczakovv:TrackPhone')
AddEventHandler('szymczakovv:TrackPhone', function(number)
  local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  local tPlayer = nil
  local chance = math.random(1, 100)

	if number == nil then
		return
	end

  if chance <= 30 then
    MySQL.Async.fetchAll('SELECT firstname,lastname,identifier from users WHERE phone_number = @phone_number', {
      ['@phone_number'] = number	
    }, function(result)
      local data = {
        first = result[1].firstname, 
        second = result[1].lastname,
        third = nil
      }
      tPlayer = ESX.GetPlayerFromIdentifier(result[1].identifier)
      data.third = tPlayer.getCoords(false)
      while tPlayer == nil do
        Wait(100)
      end
      TriggerClientEvent('szymczakovv:phoneTrackedSuccesfully', _source, data)
    end)
  else
    xPlayer.showNotification('~r~Próba namierzania nie udana.')
  end
end)

ESX.RegisterUsableItem('phonetracking', function(source)
  TriggerClientEvent('szymczakovv:showTracking', source)
end)