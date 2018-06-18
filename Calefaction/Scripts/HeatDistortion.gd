extends Sprite

const TSV = preload("res://Scripts/TemperatureScaledValue.gd")
const MAX_DISTANCE = sqrt(480 * 480 + 270 + 270) / 2

onready var temperature = $"/root/World/Temperature"
onready var distortion_factor = TSV.new(0.000, 0.004, temperature)
onready var player = $"/root/World/Player"

func _process(delta):
	if temperature.get_lerped() < 50:
		visible = false
	else:
		visible = true
		material.set_shader_param("distortionFactor", (distortion_factor.value() - 0.002) * 2)
	
	if player.position.distance_to(position) > MAX_DISTANCE:
		position = player.position