extends "genFunc.gd"

func _ready():
	randomize()
	make_rooms()


func _draw():	#Can we turn this into a mini-map?
	#Idea: 
	#	Draw corridors and rooms
	#	Mark each one depending on whether or not it's been visited?
	"""
	if Input.is_action_pressed("ui_accept"):
		Map.hide()
		for room in $Rooms.get_children():
			draw_rect(Rect2((room.position - room.size), room.size * 2),
					 Color(1, 1, 1), false)
		if path:
			for p in path.get_points():
				for c in path.get_point_connections(p):
					var pp = path.get_point_position(p)
					var cp = path.get_point_position(c)
					draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y),
							  Color(1, 1, 1), 15, true)
	if Input.is_action_just_released("ui_accept"):
		Map.show()
	"""


"""
func _input(_event):
	if Input.is_action_pressed("ui_up"):
		make_rooms()
"""

func _on_Generation_level_end():
	print("Level clear!")
	make_rooms()
