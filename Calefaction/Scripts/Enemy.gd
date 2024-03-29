extends "Entity.gd"

const ACCEL_RATE = 0.1
const SIGHTLESS_TRACK_TIME = 0.25
const PROJECTILE = preload("res://Scenes/Projectile.tscn")

onready var spin_rate = TSV.new(PI / 2, 3 * PI, temperature)
onready var tracking_range = TSV.new(100, 800, temperature)
onready var firing_range = TSV.new(100, 200, temperature)
onready var movement_speed = TSV.new(400, 800, temperature)
onready var firing_rate = TSV.new(1, 10, temperature) #per second
onready var projectile_speed = TSV.new(600, 1200, temperature)
onready var projectile_damage = TSV.new(1, 10, temperature)

var player
var projectiles
var launch_effect
var speed = 0.0
var cooldown = 0.0
var can_track = 0.0
var velocity = Vector2(0, 0)
var spawn_position

func _ready():
	spawn_position = position

func reset():
	position = spawn_position
	speed = 0.0
	cooldown = 0.0
	can_track = 0.0
	velocity = Vector2(0, 0)

func _process(delta):
	if player == null:
		player = $"/root/World/Player"
		projectiles = $"/root/World/Projectiles"
		launch_effect = projectiles.get_node("LaunchEffect")
	
	var d = dist()
	
	cooldown -= delta
	can_track -= delta
	
	if d < firing_range.value():
		speed = lerp(speed, 0, ACCEL_RATE)
		if cooldown <= 0.0 && $LineOfSight.get_collision_point().distance_to(player.position) < 20.0:
			cooldown = 1 / firing_rate.value()
			var proj = PROJECTILE.instance()
			proj.temperature = temperature
			proj.velocity = (player.position - position).normalized() * projectile_speed.value()
			proj.rotation = proj.velocity.angle() - PI / 2
			proj.position = position
			proj.damage = projectile_damage.value()
			launch_effect.play()
			projectiles.add_child(proj)
	if $LineOfSight.get_collision_point().distance_to(player.position) < 20.0:
		can_track = SIGHTLESS_TRACK_TIME
	elif d < tracking_range.value() and d > 60 && can_track > 0:
		speed = movement_speed.value()
	if d < 60:
		speed = -50.0
	
	var disp = (player.position - position).normalized() * speed
	velocity.x = lerp(velocity.x, disp.x, ACCEL_RATE)
	velocity.y = lerp(velocity.y, disp.y, ACCEL_RATE)
	move_and_slide(velocity)
	
	rotation += spin_rate.value() * delta
	
	$Texture.material.set_shader_param("temperature", temperature.get_lerped() / 100.0)
	$LineOfSight.cast_to = to_local(player.position)

func dist():
	return position.distance_to(player.position)