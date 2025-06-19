extends Node

var energy : int
var local_energy : Array

var light_gases : int # aka hydrogen and helium
var local_light_gases : Array

var heavy_gases : int # aka H2O, CO2, O2, etc.
var local_heavy_gases : Array

var bio_mass : int # Plants and animal mass
var local_bio_mass : Array

var basic_metals : int # Iron, Lead, Silver, Copper, Gold, Platinum, etc.
var local_basic_metals : Array

var rare_metals : int # Uranium, Plutonium, Thorium, etc.
var local_rare_metals : Array

var basic_materials : int # Electronics and mechanical parts
var local_basic_materials : Array

var refined_materials : int # Carbon-fiber
var local_refined_materials : Array

var exotic_materials : int # Antimatter, Strong-nuclear force material (aka neutronium), etc.
var local_exotic_materials : Array

var population : int
var local_population : Array
var happiness : float
var local_happiness : Array

var computational_power : int
var local_computational_power : Array

var current_system_id : int
var controlled_systems : int

# Called when the node enters the scene tree for the first time.
func _ready():
	energy = _sum_local(local_energy)
	light_gases = _sum_local(local_light_gases)
	heavy_gases = _sum_local(local_heavy_gases)
	bio_mass = _sum_local(local_bio_mass)
	basic_metals = _sum_local(local_basic_metals)
	rare_metals = _sum_local(local_rare_metals)
	basic_materials = _sum_local(local_basic_materials)
	refined_materials = _sum_local(local_refined_materials)
	exotic_materials = _sum_local(local_exotic_materials)
	
	population = _sum_local(local_population)
	#happiness = _sum_local(local_happiness) / controlled_systems
	computational_power = _sum_local(local_computational_power)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_system_id = Start4.current_system_id
	
	energy = _sum_local(local_energy)
	light_gases = _sum_local(local_light_gases)
	heavy_gases = _sum_local(local_heavy_gases)
	bio_mass = _sum_local(local_bio_mass)
	basic_metals = _sum_local(local_basic_metals)
	rare_metals = _sum_local(local_rare_metals)
	basic_materials = _sum_local(local_basic_materials)
	refined_materials = _sum_local(local_refined_materials)
	exotic_materials = _sum_local(local_exotic_materials)
	
	population = _sum_local(local_population)
	happiness = _sum_local(local_happiness) / (controlled_systems + 1)
	computational_power = _sum_local(local_computational_power)
	
func _sum_local(array : Array):
	var sum := 0
	for i in range(array.size()):
		sum += array[i]
	return sum
