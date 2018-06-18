extends Node2D

var last_change = 3.0
var changed = false

func _ready():
	randomize()

func _process(delta):
	$Temperature.lerp_rate = 0.01
	if randf() < 0.01 and last_change > 4.0:
		$Temperature.set(rand_range(0, 5) * 20)
		last_change = 0.0
	else:
		last_change += delta
	$Background.material.set_shader_param("temperature", $Temperature.get_lerped() / 100)
	
	if(Input.is_action_just_pressed("ui_accept") and !changed):
		changed = true
		$"/root/SceneChanger".change_scene("res://Scenes/World.tscn")
	
	if Input.is_action_just_pressed("FullScreen"):
		OS.window_fullscreen = !OS.window_fullscreen