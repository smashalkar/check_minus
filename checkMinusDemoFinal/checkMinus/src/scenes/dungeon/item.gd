extends Node2D

enum CELL_TYPES{VOID = -1, EMPTY, OBSTACLE, ACTIVE, ITEM, OBJECT, END}
export(CELL_TYPES) var type = CELL_TYPES.ITEM

var title
var description
var item_id

const speed = 1
var Map

export var resource : Resource

func _ready():
	Map = get_parent()
	title = resource.name
	description = resource.info
	self.texture = load(resource.icon)
	item_id = resource.item_type

func pre_turn():
	Map.update_position(self, position, position)
	pass

func act():
	pass

func basic():
	pass

func hit(_a, _b):
	pass
