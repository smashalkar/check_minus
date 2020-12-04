extends "movement/TestMove.gd"

var input_direction
var attack_type

export var statbase : Resource

signal turn_end

func pre_turn():
	pass

func _ready(): #Switch with initialize? 
	get_node("Sprite").texture = load("res://assets/playable/player.png")
	$Stats.initialize(statbase)

func _input(_event): #SWITCH FROM INPUT BASED, SET PRIORITY IN STATS
	if move_detected():
		input_direction = get_input_direction()
		attack_type = null
		
		$Stats.priority = 0
		emit_signal("turn_end")

	if attack_detected(): #CLEAR PRIORITY
		attack_type = 1 #Change the type of number depending on the input!
		input_direction = null
		
		$Stats.priority = $Attacks.get_priority(attack_type)
		emit_signal("turn_end")

func act():
	if attack_type != null:
		$Attacks.attack(attack_type)
		#MOVEMENT
		#pass
	
	if input_direction != null: 
		move(input_direction)
		#pass
	
	#else:
		#Thang!
		#pass

func on_death():
	print("Player died!")
	pass

func move_detected():
	return Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")

func attack_detected():
	return Input.is_action_just_pressed("ui_select") or Input.is_action_just_pressed("ui_accept")
