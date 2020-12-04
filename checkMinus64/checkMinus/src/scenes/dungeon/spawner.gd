extends TileMap

var is_player = true
var exit_spawned = false #REMINDER: EXIT IS BUGGY!
#GAME BREAKS IF AN ITEM SPAWNS ON THE EXIT!

const enemy = preload("res://src/scenes/active/enemy.tscn") #WORK OUT MULTIPLE ENCOUNTERS
const player = preload("res://src/scenes/active/player.tscn")
const exit = preload("res://src/scenes/dungeon/exit.tscn")
const item = preload("res://src/scenes/dungeon/item.tscn")

var item_count = 0
var enemy_count = 2

func spawn_manage(pos):
	if is_player:
		if exit_spawned:
			if enemy_count > 0: 
				enemy_spawn(map_to_world(pos))
				enemy_count -= 1
			else:
				pass
				#item_spawn(map_to_world(pos))
		else:
			exit_spawn(map_to_world(pos))
			exit_spawned = true
	else:
		player_spawn(map_to_world(pos))
		is_player = true

func enemy_spawn(pos):
	var newEnemy = enemy.instance()
	newEnemy.set_position(pos)
	self.add_child(newEnemy)

func player_spawn(pos):
	var mc = player.instance()
	mc.set_position(pos)
	self.add_child(mc)

func item_spawn(pos):
	var newItem = item.instance()
	newItem.set_position(pos)
	self.add_child(newItem)

func exit_spawn(pos):
	var exitTile = exit.instance()
	exitTile.set_position(pos)
	self.add_child(exitTile)
