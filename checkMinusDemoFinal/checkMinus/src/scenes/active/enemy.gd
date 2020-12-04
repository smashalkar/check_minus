extends "movement/TestMove.gd"

var basicMove = null

var vision_grid

var input_direction
var attack_type

export var statbase : Resource

var ready : bool

var wee

var enemyType = 0


func _ready():
	vision_grid = Grid #This is how we use the AI!
	get_node("Sprite").texture = load("res://assets/enemy/rat.png")
	$Stats.initialize(statbase)
	
func _init_texture():
		
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	enemyType = rng.randi() % 2
	
	if enemyType == 1:
		get_node("Sprite").texture = load("res://assets/enemy/rat.png")
	else:
		get_node("Sprite").texture = load("res://assets/enemy/squito.png")

func get_priority():
	var priority_holder = 0
	return priority_holder

func pre_turn():
	wee = Vector2(0, 1)

func act():
	pass

func on_death():
	print($Stats.id, " fainted!")
	self.queue_free()
	Grid.set_cellv(self.position, CELL_TYPES.EMPTY)
	Grid.re_order()
