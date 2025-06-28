class_name BuildingStats
extends Resources

@export var building_name : String
@export var building_mesh : MeshInstance3D
@export var building_effects : Resource

var is_unlocked : bool
var is_obtained : bool
var is_grounded : bool
var is_removeable : bool
var is_exponential_upgrade_price : bool
var buy_price : ModifiableDictionary
## Set if you want specific sell compensation, else use price_compensation_ratio
var remove_compensation : ModifiableDictionary
var price_compensation_ratio := ModifiableFloat.new(1.0)
var upgrade_price : ModifiableDictionary
var upgrade_tiers : int
var upgradeable_tiers : int
## becomes exponential if is_exponential_upgrade_price is true
var upgrade_price_ratio := ModifiableFloat.new(2.0)
