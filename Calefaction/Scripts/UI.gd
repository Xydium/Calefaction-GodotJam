extends Control

onready var temperature = $"/root/World/Temperature"
onready var player = $"/root/World/Player"

export(Gradient) var health_bar_colors
export(Gradient) var throttle_bar_colors

var last_damage_taken = 0.0
var last_score = 0.0

func _process(delta):
	$TemperatureBar.value = temperature.get_lerped()
	$TemperatureBar.get_stylebox("fg").bg_color = temperature.color_for_temp()
	$HealthBar.value = lerp($HealthBar.value, player.health, 0.1)
	$HealthBar.get_stylebox("fg").bg_color = health_bar_colors.interpolate(player.health / 1000.0)
	$ThrottleBar.value = lerp($ThrottleBar.value, player.target_speed, 0.1)
	$ThrottleBar.get_stylebox("fg").bg_color = throttle_bar_colors.interpolate((player.target_speed - 300) / 300.0)
	
	$Time.text = "%.1f" % player.time
	last_damage_taken = lerp(last_damage_taken, player.damage_taken, 0.07)
	$DamageTaken.text = "%.0f" % last_damage_taken
	$AverageTemperature.text = "%.1f" % (player.temperature_sum / player.time)
	last_score = lerp(last_score, player.score(), 0.1)
	$Score.text = "%.0fK" % (last_score / 1000.0)
	
	if player.dead and Input.is_action_just_pressed("ui_accept"):
		$"/root/SceneChanger".change_scene("res://Scenes/Menu.tscn")