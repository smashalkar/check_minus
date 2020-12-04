extends Node2D

var Room = preload("res://WIP/Room.tscn")
var Player = preload("res://src/scenes/active/player.tscn")
#var font = preload("res://assets/RobotoBold120.tres")
onready var Map = $Generation

var tile_size = 32
var num_rooms = 32

var min_size = 5 
var max_size = 12
#Try to bound perimeter by a certain number? E.g.: (assert min_size + max_size = 12), but both can individually go upto 10

var hspread = 160	#(num_rooms * 5) mostly gives square rooms. 
var cull = 0.69	#Longer pathways are a Mystery Dungeon thing, but we can change this if we need too. 

var path  # AStar pathfinding object
var start_room = null
var end_room = null
var play_mode = false  
var player = null

func _ready():
	randomize()
	make_rooms()

func make_rooms():
	for i in range(num_rooms):
		var pos = Vector2(rand_range(-hspread, hspread), 0)
		var r = Room.instance()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(w, h) * tile_size)
		$Rooms.add_child(r)
	# wait for movement to stop
	yield(get_tree().create_timer(1.1), 'timeout')
	# cull rooms
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(Vector3(int(room.position.x) - (int(room.position.x)%4),
										  int(room.position.y) - (int(room.position.y)%4), 0))
			room.position = Vector2(int(room.position.x) - (int(room.position.x)%4),
										  int(room.position.y) - (int(room.position.y)%4))
			#print(room.position, room.size)
	yield(get_tree(), 'idle_frame')
	# generate a minimum spanning tree connecting the rooms
	#print(room_positions)
	path = find_mst(room_positions)

func _draw():
	#if start_room:
		#draw_string(font, start_room.position-Vector2(125,0), "start", Color(1,1,1))
	#if end_room:
		#draw_string(font, end_room.position-Vector2(125,0), "end", Color(1,1,1))

	if play_mode:
		return
	
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2),
				 Color(1, 1, 1), false)
	
	
	if path:
		for p in path.get_points():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y),
						  Color(1, 1, 1), 15, true)

func _process(delta):
	update()

func _input(event):
	if event.is_action_pressed('ui_select'):
		if play_mode:
			player.queue_free()
			play_mode = false
		for n in $Rooms.get_children():
			n.queue_free()
		path = null
		start_room = null
		end_room = null
		make_rooms()
	if event.is_action_pressed('ui_focus_next'):
		make_map()
	if event.is_action_pressed('ui_cancel'):
		player = Player.instance()
		add_child(player)
		player.position = start_room.position
		play_mode = true

func find_mst(nodes):
	# Prim's algorithm
	# Given an array of positions (nodes), generates a minimum
	# spanning tree
	# Returns an AStar object
	
	# Initialize the AStar and add the first point
	var path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	# Repeat until no more nodes remain
	while nodes:
		var min_dist = INF  # Minimum distance so far
		var min_p = null  # Position of that node
		var p = null  # Current position
		# Loop through points in path
		for p1 in path.get_points():
			p1 = path.get_point_position(p1)
			# Loop through the remaining nodes
			for p2 in nodes:
				# If the node is closer, make it the closest
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_p = p2
					p = p1
		# Insert the resulting node into the path and add
		# its connection
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		# Remove the node from the array so it isn't visited again
		nodes.erase(min_p)
	return path

func make_map():
	# Create a TileMap from the generated rooms and path
	Map.clear()
	find_start_room()
	find_end_room()
	
	# Fill TileMap with walls, then carve empty rooms
	var full_rect = Rect2()
	for room in $Rooms.get_children():
		var r = Rect2(room.position-room.size,
					room.get_node("CollisionShape2D").shape.extents*2)
		full_rect = full_rect.merge(r)
	var topleft = Map.world_to_map(full_rect.position)
	var bottomright = Map.world_to_map(full_rect.end)
	#THIS MIGHT SLOW THINGS DOWN A LOT!
	for x in range(2*topleft.x, 2*bottomright.x):
		for y in range(2*topleft.y, 2*bottomright.y):
			Map.set_cell(x, y, 1)	#THIS IS WHAT YOU NEED TO FUCK WITH!
	
	# Carve rooms
	var corridors = []  # One corridor per connection
	for room in $Rooms.get_children():
		var s = (room.size / tile_size).floor()
		var pos = Map.world_to_map(room.position)
		var ul = (room.position / tile_size).floor() - s
		for x in range(2, s.x * 2 - 1):
			for y in range(2, s.y * 2 - 1):	#Switch numbers so that they correspond to the types. 
				Map.set_cell(ul.x + x, ul.y + y, 0)
				#Map.set_cellv()
		# Carve connecting corridor
		var p = path.get_closest_point(Vector3(room.position.x, room.position.y, 0))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.world_to_map(Vector2(path.get_point_position(p).x, path.get_point_position(p).y))
				var end = Map.world_to_map(Vector2(path.get_point_position(conn).x, path.get_point_position(conn).y))
				carve_path(start, end)
		corridors.append(p)

func carve_path(pos1, pos2):
	# Carve a path between two points
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1.0, randi() % 2)
	if y_diff == 0: y_diff = pow(-1.0, randi() % 2)
	# choose either x/y or y/x
	var x_y = pos1
	var y_x = pos2
	if (randi() % 2) > 0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(x, x_y.y, 0)
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(y_x.x, y, 0)

func find_start_room():#Change to random rooms
	var min_x = INF
	for room in $Rooms.get_children():
		if room.position.x < min_x:
			start_room = room
			min_x = room.position.x

func find_end_room():#Change to random rooms
	var max_x = -INF
	for room in $Rooms.get_children():
		if room.position.x > max_x:
			end_room = room
			max_x = room.position.x
