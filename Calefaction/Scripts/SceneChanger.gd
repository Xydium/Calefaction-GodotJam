extends CanvasLayer

var next_scene

func change_scene(path):
	$Anim.play("FadeOut")
	next_scene = path

func _swap():
	get_tree().change_scene(next_scene)
	$Anim.play("FadeIn")