extends TileMap

enum {VOID = -1, EMPTY, OBSTACLE, ACTIVE, ITEM, OBJECT, END}

var queue_total
var index_pointer
var turn_queue

signal level_end

var statbase_current

func re_order():
	queue_total = get_child_count()
	turn_queue = get_children()

func on_turn_end():
	re_order()
	for init in turn_queue:
			init.pre_turn() 
			#Make it so that bumping doesn't waste a turn. 
	for init in turn_queue:
			init.act()

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
			print("Void hit!")
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
			else:
				pass

		ACTIVE:
			if get_cell_content(dest_cell) != null:
				var content = get_cell_content(dest_cell)
				if !(content.get_node("Stats").alliance == actor.get_node("Stats").alliance):
					print("Swap would've happened here!") #Implement swaps? 
				else:
					print("Cell %s contains %s! Can't pass!" % [dest_cell, content.name])
			else:
				return update_position(actor, current_cell, dest_cell)

		END:
			for child in get_children():
				child.queue_free()
			#We need to pass stats/inventory as far upwards as humanly possible!
			print("Exit reached!")
			emit_signal("level_end")

func update_position(actor, current_cell, dest_cell):
	set_cellv(dest_cell, actor.type)
	set_cellv(current_cell, EMPTY)
	return map_to_world(dest_cell)
