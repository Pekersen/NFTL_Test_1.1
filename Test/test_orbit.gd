extends Node3D

# Orbital parameters
var a = 5.0  # semi-major axis
var e = 0.7  # eccentricity
var T = a**(3.0/2) # orbital period (in seconds)
var time_passed = 0.0  # track elapsed time

# Function to calculate the mean anomaly
func get_mean_anomaly(time_passed: float, period: float) -> float:
	return ((2 * PI) / T) * time_passed

# Function to solve Kepler's equation for eccentric anomaly using Newton's method
func solve_kepler(M: float, ecc: float, tolerance: float = 1e-6) -> float:
	var E = M  # initial guess for eccentric anomaly
	var delta = 1.0
	while abs(delta) > tolerance:
		delta = (E - ecc * sin(E) - M) / (1 - ecc * cos(E))
		E -= delta
	return E

# Function to calculate the true anomaly from the eccentric anomaly
func get_true_anomaly(E: float, ecc: float) -> float:
	return 2.0 * atan(sqrt((1.0 + ecc) / (1.0 - ecc)) * tan(E / 2.0))

# Function to calculate the radial distance at a given true anomaly
func get_radius(true_anomaly: float, semi_major_axis: float, ecc: float) -> float:
	return (semi_major_axis * (1 - ecc * ecc)) / (1 + ecc * cos(true_anomaly))

# Function to calculate the position in Cartesian coordinates
func calculate_orbit_position(time_passed: float) -> Vector3:
	var M = get_mean_anomaly(time_passed, T)
	var E = solve_kepler(M, e)
	var theta = get_true_anomaly(E, e)
	var r = get_radius(theta, a, e)
	
	# Convert polar coordinates (r, theta) to Cartesian coordinates (x, y)
	var x = r * cos(theta)
	var y = 0
	var z = r * sin(theta)
	return Vector3(x, y, z)

# Godot _process function to update the position of the orbiting object over time
func _process(delta: float):
	time_passed += delta
	
	# Calculate the current position in the elliptical orbit
	$planet.global_position = calculate_orbit_position(time_passed)
	print($planet.global_position)
	
