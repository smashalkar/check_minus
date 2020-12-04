extends "cast_manager.gd"

enum {VOID = -1, EMPTY, OBSTACLE, ACTIVE, ITEM, OBJECT, END}

var grid_size = Vector2(10, 10)
var grid = []

func _ready():
	randomize()
	for x in range(grid_size.x):
		grid.append([])
		for _y in range(grid_size.y):
			grid[x].append(null)

	var positions = []

	for _n in range(item_count + enemy_count + 2):
		var grid_pos = Vector2((randi() % int(grid_size.x)), (randi()% int(grid_size.y)))
		if not grid_pos in positions:
			positions.append(grid_pos)

	for pos in positions:
		spawn_manage(pos)

	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)

"""
	index_pointer = 0
	queue_total = get_child_count()
	turn_queue = get_children()
	print("It is %s's turn!" % [get_child(index_pointer)])
	queue_turn()
	print("It is %s's turn!" % [get_child(index_pointer)])
"""

func get_cell_content(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)

func request_move(actor, direction):
	var current_cell = world_to_map(actor.position)
	var dest_cell = current_cell + direction

	var dest_cell_type = get_cellv(dest_cell)
	match dest_cell_type:
		
		VOID:
			return update_position(actor, current_cell, dest_cell)

		EMPTY:
			return update_position(actor, current_cell, dest_cell)

		ITEM:
			var object_actor = get_cell_content(dest_cell)
			var not_full = actor.get_node("Inventory").add_item(object_actor.item_id)
			print("%s accquired one %s!" % [actor.get_node("Stats").id, object_actor.title])
			if not_full:
				object_actor.queue_free()
			re_order()
			return update_position(actor, current_cell, dest_cell)

		ACTIVE: #IMPLEMENT SWAP FOR SAME TYPES
			if get_cell_content(dest_cell) != null:
				var content = get_cell_content(dest_cell)
				if !(content.get_node("Stats").alliance == actor.get_node("Stats").alliance):
					print("Swap would've happened here!") #Implement swaps? 
				else:
					print("Cell %s contains %s! Can't pass!" % [dest_cell, content.name])
			else:	#THIS APPROACH MIGHT BE BUGGY
				return update_position(actor, current_cell, dest_cell)

		END: #MAYBE SWITCH END TO SOMETHING ELSE
			print("Exit reached!")

func update_position(actor, current_cell, dest_cell):
	set_cellv(dest_cell, actor.type)
	set_cellv(current_cell, EMPTY)
	return map_to_world(dest_cell)


func _on_turn_end():
	re_order()
	for init in turn_queue:
			init.pre_turn() #Make it so that bumping doesn't waste a turn. 
	for init in turn_queue:
			init.act()
			print(init)
