extends "grid_class.gd"

const move_speed = 6
onready var Grid = get_parent()

var current_direction

func _ready():
	current_direction = Vector2(1, 0)
	#$Stats.initialize($Stats.statbase)
	$Stats.alliance = PLAYER_TYPES.MAIN
	
	$Attacks.Grid = Grid
	$Attacks.user = self

func move(input_direction):#MOVE INPUT DIRECTION TO MAIN
	
	current_direction = input_direction
	var target_position = Grid.request_move(self, input_direction)
	
	if target_position:
		move_to(target_position)
		update_look_direction(current_direction)
	else:
		bump()

#Switch to 'just_pressed' if controlling enemies manually, 'pressed' otherwise.
func get_input_direction():
	return Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)

func move_to(target_position):
	set_process_input(false)
	$Tween.interpolate_property(
		self,"position",
		position, target_position, 0,
		Tween.TRANS_LINEAR, Tween.EASE_IN) #SWITCH SPEED WITH $AnimationPlayer.current_animation_length

	$Tween.start()
	#yield($AnimationPlayer, "animation_finished")
	set_process_input(true)

func bump():
	set_process_input(false)
	#print("Ouch! No space here!")
	#Animation (if we have one for bumps) goes here
	set_process_input(true)

func update_look_direction(_direction):
	#Dillon needs to switch sprites here if he wants to update them according to 'look' directions. 
	pass
	#$Sprite.rotation = direction.angle()

func hit(hurt, dmg):
	$Stats.hit(hurt, dmg)
