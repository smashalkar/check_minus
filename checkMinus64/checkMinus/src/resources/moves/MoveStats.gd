extends Resource

class_name testMove
export var is_move = false #Set 'false' for the place-holder move, might be able to get away with checking for NULL instead

#Basic Move Info
export var name : String = "--"
export var info : String = "--"

export var baseDamage : int
export(int, 0, 100) var accuracy : int
export(int, 0, 255) var cost : int
export(int, 0, 100) var crit_chance : int

#attackType: 0 - Hurt, 1 - Heal, ---
#attackStyle: 0 - Straight, 1 - Wide Slash, 2 - AoE, 3 - Closest, 4 - All
export(int, 0, 1) var type : int = 0 
export(int, 0, 4) var style : int = 0
export var hit_range : int = 1
export var max_times : int = 1

export var priority : int = 0

#Status Effects
#sides: 0 - Nothing, 1 = Poison, 2 = Burn, ß
export(int, 0, 1) var effect : int = 0
export(int, 0, 100) var chance : int = 30

#Buffs/Debuffs and other stuff (Other side effects?)
var stat_array : Array = [0, 0, 0]
var extraDmg : int = 0
