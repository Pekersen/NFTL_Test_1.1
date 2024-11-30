class_name GenerateCluster extends Node3D

var cluster_type : String
var cluster_age_variance : Array[float]
var cluster_age : int

var rng = RandomNumberGenerator.new()

func offsetValue(offset : Array):
	if typeof(offset[0]) == TYPE_FLOAT:
		return rng.randf_range(offset[0], offset[1])
	elif typeof(offset[0]) == TYPE_INT:
		return rng.randi_range(offset[0], offset[1])
	
func cluster_variables():
	var random_float = randf() * 2
	
	if random_float < 0.33:
		cluster_age_variance = [1000000000, 10000000000]
	elif random_float < 0.66:
		cluster_age_variance = [100000000, 999999999]
	elif random_float < 1.0:
		cluster_age_variance = [0, 99999999]
	else:
		cluster_age_variance = [10000000000, 14000000000]
	
	cluster_age = offsetValue(cluster_age_variance)
	
	if cluster_age < 99999999:
		cluster_type = "Association"
	elif cluster_age < 999999999:
		cluster_type = "Open"
	elif cluster_age < 10000000000:
		cluster_type = "Globular"
	else:
		cluster_type = "none"
	
	print("Cluster Age: " + str(cluster_age) + ", Cluster Type: " + cluster_type)
