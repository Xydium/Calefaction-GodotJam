extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("Restart"):
		$Temperature.reset()
		$Player.reset()
		for enemy in $Enemies.get_children():
			enemy.reset()
		$CanvasLayer/UI.reset()
