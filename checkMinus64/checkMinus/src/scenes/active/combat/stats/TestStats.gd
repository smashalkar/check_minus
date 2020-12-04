extends Node
#ADD 'PRIORITY' FLAG TO STATS

#export var statbase : Resource

class_name charStats

#Dictionary, used for action logs:
const MODIFIER_KEY = {0 : "speed", 1 : "offense", 2 : "defense"}
const STATUS_KEY = {1 : "poisoned", 2 : "burned", 3 : "paralysed"}

var id : String
var alliance : int	#The plan is to set an 'alliance' flag for each team on the map

#Levels
var experience : int = 1
var current_level : int = 1
var to_next : int = 7
var exp_yield : int = 35

var priority : int

#Buff/debuff + maximum stack allowed:
var modifiers = [0, 0, 0]
var MAX_STAT_VARIANCE = 3

#Stats:
var max_health : int
var max_mana : int
var health : int setget set_health
var mana : int setget set_mana
var offense : int
var defense : int
var speed : int

var is_status : bool
var status_effect : int

func initialize(stats):
	id = stats.id
	max_health = stats.health
	max_mana = stats.mana
	offense = stats.offense
	defense = stats.defense
	speed = stats.speed
	health = max_health
	mana = max_mana
	get_parent().name = id

func set_health(value):
	health = int(min(max_health, value))

func set_mana(value):
	max_mana = int(min(max_mana, value))

func get_health():
	return int(health)

func get_mana():
	return int(mana)

func health_change(heal : bool, amount : int):
	if heal:
		health += amount
	else:
		health -= amount

func boost(stat : int, mult : int):
	modifiers[stat] += mult
	print("%s's %s increased by %s!" % [id, MODIFIER_KEY[stat], mult])
	if modifiers[stat] > MAX_STAT_VARIANCE:
		print("%s's %s cannot go any higher!" % [id, MODIFIER_KEY[stat]])
		modifiers[stat] = MAX_STAT_VARIANCE

func decrease(stat : int, mult : int):
	modifiers[stat] -= mult
	print("%s's %s decreased by %s!" % [id, MODIFIER_KEY[stat], mult])
	if modifiers[stat] < -MAX_STAT_VARIANCE:
		print("%s's %s cannot be lowered any further!" % [id, MODIFIER_KEY[stat]])
		modifiers[stat] = -MAX_STAT_VARIANCE

func status(effect):
	if !(is_status):
		status_effect = effect
		print("%s has been %s!" % [id, STATUS_KEY[effect]])
		pass
	else:
		print("%s is already %s!" % [id, status_effect])
		pass

func _on_defeated(xp_points):
	if current_level != 100: 
		experience += xp_points
		while experience >= int(((current_level + 1)^3)*(4/5)) and current_level != 100:
			current_level += 1
	if current_level != 100: 
		to_next = int(((current_level + 1)^3)*(4/5)) - experience
	else: 
		to_next = 0

func hit(hurt : bool, dmg : int): #WORK ON THIS, MOVE TO STATS
	print(health)
	if hurt: 
		pass
	if health < 1: 
		pass
	else:
		health -= dmg
		print("%s took %s damage!" % [id, dmg])
		if health < 1:
			get_parent().on_death()
