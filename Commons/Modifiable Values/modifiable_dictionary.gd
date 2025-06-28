class_name ModifiableDictionary
extends Resource

var base_values: Dictionary
var flat_modifiers_per: Dictionary # Dict of arrays of floats
var flat_modifiers_all: Array[float] = []
var percent_modifiers_per: Dictionary # Dict of arrays of floats
var percent_modifiers_all: Array[float] = []

func _init(_base_values: Dictionary):
	base_values = _base_values

func get_values() -> Dictionary:
	var total_flat_all = flat_modifiers_all.reduce(func(a, b): return a + b, 0.0)
	var total_percent_all = percent_modifiers_all.reduce(func(a, b): return a + b, 0.0)
	var modified_values = base_values * (1.0 + total_percent_all) + total_flat_all
	for key in base_values.keys():
		if percent_modifiers_per.has(key):
			modified_values *= flat_modifiers_per.get(key).reduce(func(a, b): return a + b, 0.0)
		if flat_modifiers_per.has(key):
			modified_values += flat_modifiers_per.get(key).reduce(func(a, b): return a + b, 0.0)
	return modified_values

func get_value(key : String) -> float:
	return get_values().get(key)
