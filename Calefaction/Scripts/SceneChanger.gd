extends CanvasLayer

var next_scene

func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

func change_scene(path):
	$Anim.play("FadeOut")
	next_scene = path

func _swap():
	get_tree().change_scene(next_scene)
	$Anim.play("FadeIn")