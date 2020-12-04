extends Node

func effect(Grid, user):
	var in_front = Grid.get_cell_content(Grid.world_to_map(user.position) + user.current_direction)
	if in_front == null:
		print("Miss!")
	else:
		in_front.hit(false, 5)
