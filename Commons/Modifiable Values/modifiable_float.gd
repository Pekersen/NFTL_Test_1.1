class_name ModifiableFloat
extends Resource

var base_value: float
var flat_modifiers: Array[float] = []
var percent_modifiers: Array[float] = []

func _init(_base_value: float):
	base_value = _base_value

func get_value() -> float:
	var total_flat = flat_modifiers.reduce(func(a, b): return a + b, 0.0)
	var total_percent = percent_modifiers.reduce(func(a, b): return a + b, 0.0)
	return (base_value + total_flat) * (1.0 + total_percent)
