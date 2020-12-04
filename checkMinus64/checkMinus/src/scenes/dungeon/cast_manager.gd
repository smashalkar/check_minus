extends "spawner.gd"

var queue_total
var index_pointer
var turn_queue

var ready = false

func _ready():
	turn_queue = get_children()
	queue_total = get_child_count()

"""
func _on_end(): 
	#MAKE THE QUEUE HANDLING A 'PROCESS' FUNCTION
	#1. Get an initial 'attack' flagger.
	#2. Sort queue by 'speed' and 'priority.' 
	#3. Run queue actions.
	#3. 1. Check for deaths after each attack, then update the queue.
	index_pointer += 1
	index_pointer %= queue_total
	if index_pointer == 0:
		print("New Turn!")
	queue_turn()

func queue_turn():
	print("Turn ended!")
	if turn_queue[index_pointer] != null:
		yield(turn_queue[index_pointer], "end")
"""
func re_order():
	queue_total = get_child_count()
	turn_queue = get_children()

func _on_Player_test():
	re_order()
	for init in turn_queue:
			init.pre_turn() #Make it so that bumping doesn't waste a turn. 
	for init in turn_queue:
			init.act()
