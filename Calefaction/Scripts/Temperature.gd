extends Node

const COOLING_RATE = 2.0 #degrees/second
const MIN_TEMP = 0.0
const MAX_TEMP = 100.0

export(Gradient) var temp_color_ramp

var temperature = 0.0 setget set, get
var lerped_temperature = temperature setget, get_lerped
var auto_cool = false
var lerp_rate = 0.07

func _process(delta):
	lerped_temperature = lerp(lerped_temperature, temperature, lerp_rate)
	
	if auto_cool:
		cool_down(COOLING_RATE * log(lerped_temperature + 1), delta)

func get():
	return temperature

func get_lerped():
	return lerped_temperature

func set(new_temperature):
	temperature = clamp(new_temperature, MIN_TEMP, MAX_TEMP)

func heat_up(rate, delta):
	self.temperature += rate * delta

func cool_down(rate, delta):
	self.temperature -= rate * delta

func scaled(base_val, max_val):
	return base_val + (max_val - base_val) * (lerped_temperature / MAX_TEMP)

func color_for_temp():
	return temp_color_ramp.interpolate(temperature / MAX_TEMP)

func reset():
	temperature = MIN_TEMP
	lerped_temperature = temperature