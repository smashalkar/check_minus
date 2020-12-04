extends Node

var is_move : bool

var id : String
var info : String

var baseDamage : int
var accuracy : int = 100
var cost : int
var crit_chance : int

var type : int
var style : int
var hit_range : int
var max_times : int

var status_effect : int
var effect_chance : int

var priority : int

var buff_chance : int = 0
var buff_effect : int = 0
var stat_array : Array = [0, 0, 0, 0]

var extraDmg : int = 7

var extra = 0
signal all


func initialize(move):
	if move == null:
		is_move = false
	
	else:
		baseDamage = move.baseDamage
		accuracy = move.accuracy
		cost = move.cost
		crit_chance = move.crit_chance

		type = move.type
		style = move.style
		hit_range = move.hit_range
		max_times = move.max_times


#First layer should be self/other.
func effect(Grid, user): 	#Try to send positions one-by-one instead?
	print("Executed!")
	randomize()
	if max_times > 1: 
		extra = ((randi() % max_times) + 1)
	else: 
		extra = 1
	for _x in range(extra):
		if (randi() % 100) > accuracy:
			pass
		else: #Might need work since it'll always go through walls. 
			match style: #ADD A BOOL FOR CRIT
				0:
					for i in range(hit_range):
						var in_front = Grid.get_cell_content(Grid.world_to_map(user.position) + ((i + 1) * user.current_direction))
						if in_front != null:
							attk_func(false, in_front) #CHANGE TO NEXT JUMP
				1: 
					print("Condition for wide slash here! But how?")
					if user.current_direction == Vector2(0, 0):
						print("Hit it where?")
						pass
					elif user.current_direction.x == 0:
						print("You were facing x-ward!")
						pass
					elif user.current_direction.y == 0:
						print("You were facing y-ward!")
						pass
					else:
						print("You were facing diagon-ward!")
						pass
				2:
					for i in range(hit_range + hit_range):
						for j in range(hit_range + hit_range):
							if (i != hit_range) or (j != hit_range):
								var in_front = Grid.get_cell_content(Grid.world_to_map(user.position) + Vector2(i - hit_range, j - hit_range))
								if in_front != null:
									attk_func(false, in_front)
				3:
					print("Auto-aim to closest here!")
					print("Djikstra's, maybe?!")
				4:
					emit_signal("all")

func attk_func(truth, in_front):	#Put critical hits here? 
	in_front.hit(truth, 5)
	pass

func side_effect():
	pass

func status_proc():
	randomize()
	if (randi() % 100) > effect_chance: 
		match status_effect:
			0:
				print("Weak!")
				pass
			1:
				print("Oh snap! You just got BURNED!")
				pass
			2:
				print("Oh snap! You're TOXIC!")
				pass
	randomize()
	if (randi() % 100) > buff_chance:
		match buff_effect:
			0:
				pass
			1:
				pass

func stat_debuff(in_front):
	in_front.get_node("Stats").decrease(stat_array)
	pass

func stat_buff(in_front):
	in_front.get_node("Stats").boost(stat_array)
	pass

func extra_hit(in_front):
	in_front.hit(false, extraDmg)
	pass


