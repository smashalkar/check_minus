extends RigidBody2D

var size
var start : bool = false
var end : bool = false

var insideNow : bool = false
var visited : bool = false

func make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = 0.75
	s.extents = size
	$CollisionShape2D.shape = s

"""
func get_positions(num : int):
	print("POSITIONS:")
	print(position, size)
	#var x_adjusted = (int(position.x) + randi()%int(size.x) - 2) - (int(position.x) + randi()%int(size.x) - 2)%4
	#var y_adjusted = (int(position.y) + randi()%int(size.y) - 2) - (int(position.y) + randi()%int(size.y) - 2)%4
	#return Vector2(x_adjusted, y_adjusted)	#NEED TO CALCULATE AN ACTUAL POSITION
	return Vector2(0,0)
	pass
"""
