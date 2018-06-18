extends Area2D

var temperature
var damage
var velocity
var time_to_die = 0.0

func _ready():
	position += velocity.normalized() * 20

func _process(delta):
	position += velocity * delta
	$Texture.material.set_shader_param("temperature", temperature.get_lerped() / 100)
	if not $Texture.emitting:
		time_to_die -= delta
		if time_to_die < 0.0:
			queue_free()

func _on_collision(body):
	if body.name.find("Enemy") != -1 or not $Texture.emitting: return
	if body.name == "Player":
		body.take_damage(damage, velocity)
	$Texture.emitting = false
	time_to_die = 3.0
