extends TileMap

const TSV = preload("res://Scripts/TemperatureScaledValue.gd")

onready var shader_temp = TSV.new(0.0, 1.0, $"/root/World/Temperature")

func _process(delta):
	material.set_shader_param("temperature", shader_temp.value())
	
	if Input.is_action_just_pressed("FullScreen"):
		OS.window_fullscreen = !OS.window_fullscreen