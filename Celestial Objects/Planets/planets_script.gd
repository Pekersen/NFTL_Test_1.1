class_name Planet extends CelestialObject

@export var rotationPoint : Node3D

var num_moons : int
var rings : bool
var ring_size : float
var tidally_locked : bool
var rotation_speed : float
var tilt : float

var atmospheric_composition : Array[float]

const ORBIT_SPEED_CONST := 20
var semi_major_axis: float
var eccentricity: float
var orbital_period: float # in seconds
var time_passed = 0.0 # track elapsed time

func orbit(delta, core):
	time_passed += delta * Global.ticks_per_second / ORBIT_SPEED_CONST
	
	# Calculate the current position in the elliptical orbit
	core.global_position = calculate_orbit_position(time_passed)

# Function to calculate the mean anomaly
func get_mean_anomaly(time_passed: float, period: float) -> float:
	return ((2 * PI) / orbital_period) * time_passed

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
	var M = get_mean_anomaly(time_passed, orbital_period)
	var E = solve_kepler(M, eccentricity)
	var theta = get_true_anomaly(E, eccentricity)
	var r = get_radius(theta, semi_major_axis , eccentricity)
	
	# Convert polar coordinates (r, theta) to Cartesian coordinates (x, y)
	var x = r * cos(theta)
	var y = 0
	var z = r * sin(theta)
	return Vector3(x, y, z)

# Offset values
var distance_variance : Array[float]
var num_moons_variance : Array[float]
var ring_size_variance : Array[float]
var rotation_speed_variance : Array[float]
var tilt_variance : Array[float]
var atomospheric_composition_variance : Array[float]
var orbit_speed_variance : Array[float]

# For Brown Dwarves
"""
var luminosity : float
var luminosity_variance : Array[float]

var color_r : float
var color_g : float
var color_b : float

var color_variance_r : Array[float]
var color_variance_g : Array[float]
var color_variance_b : Array[float]
"""
