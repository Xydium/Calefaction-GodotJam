extends "Entity.gd"

var SPEED_RANGE = Vector2(300, 600) #pixels/second
const TARGET_ACCEL_RATE = 100 #pixels/second^2
const VEL_LERP_RATE = 0.1
const VELOCITY_HEAT_FACTOR = 0.005
const TIME_TO_REGEN = 3 #seconds
const REGEN_RATE = 10 #hp/sec
const SPIN_RATE = deg2rad(720) #deg/sec

onready var safezone = $"/root/World/Terrain/SafeZone"

var target_speed = SPEED_RANGE.x
var velocity = Vector2(0, 0)
var health = 1000
var last_hit_ms = 0
var actual_spin_rate = SPIN_RATE
var time = 0.0
var damage_taken = 0.0
var temperature_sum = 0.0
var dead = false
var spawn_position

func _ready():
	configure_camera_limits()
	spawn_position = position

func reset():
	position = spawn_position
	target_speed = SPEED_RANGE.x
	velocity = Vector2(0, 0)
	health = 1000
	last_hit_ms = 0
	actual_spin_rate = SPIN_RATE
	time = 0.0
	damage_taken = 0.0
	temperature_sum = 0.0
	dead = false

func _process(delta):
	if not dead:
		if Input.is_action_pressed("Accelerate"):
			change_target_speed(1, delta)
		elif Input.is_action_pressed("Decelerate"):
			change_target_speed(-1, delta)
	
	time += delta
	temperature_sum += temperature.get_lerped() * delta
	
	var accelerating = accelerate_in_direction(get_input_direction())
	$MoveEffect.pitch_scale = 1 + log(velocity.length() / 3) / 2
	if velocity.length() > 1 and not $MoveEffect.playing:
		$MoveEffect.play()
	elif velocity.length() < 1 and $MoveEffect.playing:
		$MoveEffect.stop()
	
	var displacement = move_and_slide(velocity)
	for i in get_slide_count():
		var norm = get_slide_collision(i).normal.rotated(PI / 2)
		velocity = velocity.reflect(norm)
		if actual_spin_rate > 0.5:
			$BounceEffect.play()
		actual_spin_rate = 0
	
	temperature.heat_up(displacement.length() * VELOCITY_HEAT_FACTOR, delta)
	temperature.auto_cool = !accelerating and !dead
	
	last_hit_ms += delta
	if last_hit_ms > TIME_TO_REGEN:
		health += REGEN_RATE * delta
		health = clamp(health, 0, 1000)
	
	$Texture.rotation += actual_spin_rate * delta
	actual_spin_rate = lerp(actual_spin_rate, SPIN_RATE, 6 / target_speed)
	
	if position.distance_to(safezone.position) < 50.0 and not dead:
		win()
	
	recolor_effects()

func get_input_direction():
	if dead: return Vector2(0, 0)
	var direction = Vector2(0, 0)
	if Input.is_action_pressed("MoveUp"):
		direction.y = -1
	elif Input.is_action_pressed("MoveDown"):
		direction.y = 1
	if Input.is_action_pressed("MoveLeft"):
		direction.x = -1
	elif Input.is_action_pressed("MoveRight"):
		direction.x = 1
	return direction

func accelerate_in_direction(direction):
	var magnitude = direction.length()
	if(magnitude == 0):
		magnitude = 1
	velocity.x = lerp(velocity.x, direction.x * target_speed / magnitude, VEL_LERP_RATE)
	velocity.y = lerp(velocity.y, direction.y * target_speed / magnitude, VEL_LERP_RATE)
	
	return direction.length() > 0

func change_target_speed(direction, delta):
	target_speed = clamp(target_speed + TARGET_ACCEL_RATE * direction * delta, SPEED_RANGE.x, SPEED_RANGE.y)

func die():
	$"/root/World/Anim".play("ShowEnd")
	$"/root/World/CanvasLayer/EndScreen/Dead".visible = true
	$"/root/World/CanvasLayer/EndScreen/ScoreValue".text = str(int(score()))

func win():
	dead = true
	$"/root/World/Anim".play("ShowEnd")
	$"/root/World/CanvasLayer/EndScreen/Win".visible = true
	$"/root/World/CanvasLayer/EndScreen/ScoreValue".text = str(int(score() + 10000000))

func score():
	return (100000 * (exp(-time / 60) + exp(-damage_taken / 100)) * (1 + temperature_sum / (time + 1)))

func take_damage(amount, impulse):
	$HitEffect.play()
	$Camera.shake_magnitude += impulse.length() / 50
	velocity += impulse * 0.2
	health -= amount
	damage_taken += amount
	last_hit_ms = 0
	if(health <= 0 and not dead):
		dead = true
		health = 0
		die()

func recolor_effects():
	$Fireball.process_material.color.g = ((target_speed - 300) / 600)
	$Fireball.process_material.color.b = $Fireball.process_material.color.g
	
	$"/root/World/Blur".position = position

func configure_camera_limits():
	var limits = $"/root/World/Terrain".get_used_rect()
	var cam = $Camera
	cam.limit_left = int(limits.position.x) * 30
	cam.limit_right = int(limits.position.x + limits.size.x) * 30
	cam.limit_top = int(limits.position.y) * 30
	cam.limit_bottom = int(limits.position.y + limits.size.y) * 30