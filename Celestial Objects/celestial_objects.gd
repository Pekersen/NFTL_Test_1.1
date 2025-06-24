class_name CelestialObject extends Node3D

@export var core : Node3D

const ORIGINAL_AXIS_OF_ROTATION = Vector3.UP  # (0, 1, 0)

var radius : float
var mass : float
var temperature : float # THIS IS THE AVERAGE TEMPERATURE, NOT THE CURRENT TEMP
var axial_tilt : Vector3
var axis_of_rot : Vector3
var rotations_per_tick : float
var rotation_velocity : float

# for randomness
var rng = RandomNumberGenerator.new()

# offsets
var radius_variance : Array[float]
var mass_variance : Array[float]
var temperature_variance : Array[float]
var axial_tilt_variance : Array[float]
var rotation_speed_variance : Array[float]

const ORBIT_SPEED_CONST := 20
var time_passed := 0.0

var can_orbit := false
var is_flipped := false

var semi_major_axis: float
var semi_minor_axis: float # not needed for orbit
var eccentricity: float
var orbital_period: float # in seconds

var object_name : String

# When clicking on an object, there will be additional space where the click will go through even
# though user is clicking on nothing visually
var click_forgiveness : float = 1.0

func offset_value(offset : Array[float]):
	return rng.randf_range(offset[0], offset[1])

# moves 'core' in an orbit
func orbit(delta, core_obj):
	if can_orbit:
		time_passed += delta * Global.ticks_per_second / ORBIT_SPEED_CONST
		
		# Calculate the current position in the elliptical orbit
		core_obj.position = calculate_orbit_position(time_passed)

# Function to calculate the position in Cartesian coordinates
func calculate_orbit_position(time: float) -> Vector3:
	var M = get_mean_anomaly(time)
	var E = solve_kepler(M, eccentricity)
	var theta = get_true_anomaly(E, eccentricity)
	var r = get_radius(theta, semi_major_axis , eccentricity)
	
	# Convert polar coordinates (r, theta) to Cartesian coordinates (x, y)
	var x = r * cos(theta)
	var y = 0
	var z = r * sin(theta)
	return Vector3(x, y, z)

# Function to calculate the mean anomaly
func get_mean_anomaly(time: float) -> float:
	return ((2 * PI) / orbital_period) * time

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
func get_radius(true_anomaly: float, semi_major: float, ecc: float) -> float:
	return (semi_major * (1 - ecc * ecc)) / (1 + ecc * cos(true_anomaly))
	
func init_orbit_mesh(orbitMesh: Node3D, initRotPos: float = 0):
	orbitMesh.rotation.y = initRotPos
	orbitMesh.scale.z = semi_minor_axis/semi_major_axis
	var total_distance = -sqrt(pow(semi_major_axis,2) - pow(semi_minor_axis,2))
	#orbitMesh.position.x = total_distance
	orbitMesh.translate(Vector3(total_distance,0,0))
	
	if is_flipped:
		orbitMesh.position.x *= -1
		
func celestial_rotation(delta, obj):
	calc_axis_of_rot()
	rotation_velocity = -rotations_per_tick * delta * Global.ticks_per_second
	obj.rotate(axis_of_rot, rotation_velocity)
	
func calc_axis_of_rot():
	var basis = Basis(Vector3.RIGHT, axial_tilt.x) * Basis(Vector3.FORWARD, axial_tilt.z)
	axis_of_rot = (basis * ORIGINAL_AXIS_OF_ROTATION).normalized()
