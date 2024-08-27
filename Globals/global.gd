extends Node

# GUI area
var time_speed: float
# end of GUI area

func set_time_speed(value: float):
	print("asdsad")
	if value < 0:
		value = 0
	time_speed = value
	return "Time speed was set to " + str(time_speed)
