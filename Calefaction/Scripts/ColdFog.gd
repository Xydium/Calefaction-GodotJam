extends Particles2D

const TSV = preload("res://Scripts/TemperatureScaledValue.gd")

onready var temperature = $"/root/World/Temperature"
onready var sparkles = $"../ColdSparkles"
onready var coldFactor = TSV.new(1.0, -1.0, temperature)

func _process(delta):
	if temperature.get() > 50:
		if emitting:
			emitting = false
			sparkles.emitting = false
	else:
		if !emitting:
			emitting = true
			sparkles.emitting = true
		modulate.a = coldFactor.value()
		sparkles.modulate.a = coldFactor.value()