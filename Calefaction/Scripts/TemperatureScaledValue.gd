extends Reference

var base_val
var max_val
var temperature_src

func _init(base_val, max_val, temperature_src):
	self.base_val = base_val
	self.max_val = max_val
	self.temperature_src = temperature_src

func value():
	return temperature_src.scaled(base_val, max_val)