extends Camera2D

const NOISE = preload("res://Scripts/Noise.gd")

var noise = NOISE.SoftNoise.new()

var shake_magnitude = 0.0

var time = 0

func _process(delta):
	time += delta
	if shake_magnitude > 1:
		shake_magnitude *= 0.75
		pass
	else:
		shake_magnitude = 0.0
	
	offset.x = noise.openSimplex2D(time * shake_magnitude, 0) * shake_magnitude
	offset.y = noise.openSimplex2D(time * shake_magnitude + 1000, 100) * shake_magnitude
	
	$"/root/World/ColorAberration".material.set_shader_param("glitch_amount", shake_magnitude)