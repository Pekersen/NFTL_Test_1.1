class_name BuildingStats
extends Resource


static var uid : int = 0
@export var building_name : String
@export var production: ProductionComponent = null
@export var unlock: UnlockComponent = null

var is_unlocked : bool
var is_obtained : bool
var is_grounded : bool
var is_removeable : bool
var is_exponential_upgrade_price : bool
var buy_price : ModifiableDictionary = null
## Set if you want specific sell compensation, else use price_compensation_ratio
var remove_compensation : ModifiableDictionary = null
var price_compensation_ratio := ModifiableFloat.new(1.0)
var upgrade_price : ModifiableDictionary = null
var upgrade_tiers : int
var upgradeable_tiers : ModifiableInt
## becomes exponential if is_exponential_upgrade_price is true
var upgrade_price_ratio := ModifiableFloat.new(2.0)

func _ready():
	uid = _generate_uid()

static func _generate_uid():
	uid += 1
