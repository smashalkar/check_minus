extends Sprite

var speed = 1 #Get Speed Function?

enum CELL_TYPES{VOID = -1, EMPTY, OBSTACLE, ACTIVE, ITEM, OBJECT, END}
export(CELL_TYPES) var type = CELL_TYPES.END

var Map

func _ready():
	self.texture = load("res://assets/tilesets/stairs.png")
	Map = get_parent()

func pre_turn():
	Map.update_position(self, position, position)
	pass

func act():
	Map.set_cellv(Map.world_to_map(self.position), self.type)
	pass

func hit(_a, _b):
	pass
