extends Node

onready var temperature = $"/root/World/Temperature"

onready var cs = $ColdSynths
onready var ms = $MediateSynths
onready var hs = $HotSynths
onready var sz = $Sizzle
onready var wind = $Wind

func _process(delta):
	var temp = temperature.get_lerped() / temperature.MAX_TEMP
	if temp <= 0.25:
		wind.volume_db = linear2db(1 - (temp * 4)) - 5
		cs.volume_db = 0
		ms.volume_db = -80
		hs.volume_db = -80
	elif temp <= 0.5:
		cs.volume_db = linear2db(1 - (temp - 0.25) * 4)
		ms.volume_db = linear2db((temp - 0.25) * 4)
		hs.volume_db = -80
	elif temp <= 0.75:
		cs.volume_db = -80
		ms.volume_db = linear2db(1 - (temp - 0.50) * 4)
		hs.volume_db = linear2db((temp - 0.50) * 4) - 3
		sz.volume_db = -80
	else:
		cs.volume_db = -80
		ms.volume_db = -80
		hs.volume_db = -3
		sz.volume_db = linear2db((temp - 0.75) * 4) - 2