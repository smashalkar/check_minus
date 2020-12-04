extends Resource

class_name testPersonal

#Player Type Info
export var self_id : String

#Experience/Levels
export var experience : int = 1
export(int, 1, 100) var current_level : int = 1

export var to_next : int = 7
export(int, 30, 700) var exp_yield : int = 35

#Player Individual Stats
export var health : int = 20
export var mana : int = 10

export var offense : int = 8
export var defense : int = 8
export var speed : int = 8

#Special Attack Stats
export var special_one : String = "res://TestNullAttacks.tres"
export var special_two : String = "res://TestNullAttacks.tres"
export var special_three : String = "res://TestNullAttacks.tres"
export var special_four : String = "res://TestNullAttacks.tres"

