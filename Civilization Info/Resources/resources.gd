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
var controlled_systems = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	local_energy.resize(controlled_systems)
	local_light_gases.resize(controlled_systems)
	local_heavy_gases.resize(controlled_systems)
	local_bio_mass.resize(controlled_systems)
	local_basic_metals.resize(controlled_systems)
	local_rare_metals.resize(controlled_systems)
	local_basic_materials.resize(controlled_systems)
	local_refined_materials.resize(controlled_systems)
	local_exotic_materials.resize(controlled_systems)
	
	local_population.resize(controlled_systems)
	local_happiness.resize(controlled_systems)
	local_computational_power.resize(controlled_systems)
	#energy = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	current_system_id = Start4.current_system_id
	
	if local_energy[0] != null:
		energy = _sum_local(local_energy)
	if local_light_gases[0] != null:
		light_gases = _sum_local(local_light_gases)
	if local_heavy_gases[0] != null:
		heavy_gases = _sum_local(local_heavy_gases)
	if local_bio_mass[0] != null:
		bio_mass = _sum_local(local_bio_mass)
	if local_basic_metals[0] != null:
		basic_metals = _sum_local(local_basic_metals)
	if local_rare_metals[0] != null:
		rare_metals = _sum_local(local_rare_metals)
	if local_basic_materials[0] != null:
		basic_materials = _sum_local(local_basic_materials)
	if local_refined_materials[0] != null:
		refined_materials = _sum_local(local_refined_materials)
	if local_exotic_materials[0] != null:
		exotic_materials = _sum_local(local_exotic_materials)
	
	if local_population[0] != null:
		population = _sum_local(local_population)
	if local_happiness[0] != null:
		happiness = _sum_local(local_happiness) / (controlled_systems + 1)
	if local_computational_power[0] != null:
		computational_power = _sum_local(local_computational_power)
	
	
	
func _sum_local(array : Array):
	var sum = 0
	for i in array:
		sum += i
	return sum
