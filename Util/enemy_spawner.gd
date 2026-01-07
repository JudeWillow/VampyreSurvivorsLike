extends Node2D

@export var spawns: Array[spawnInfo] = []

@onready var player = get_tree().get_first_node_in_group("player")
var time = 0


func _on_timer_timeout() -> void:
	time += 1
	var enemySpawns = spawns ## enemySpawns is our export array of spawnInfo
	for i in enemySpawns:
		if time >= i.timeStart and time <= i.timeEnd: ## Time has to be inbetween timestart and timeend
			if i.spawnDelayCounter < i.enemySpawnDelay: 
				i.spawnDelayCounter += 1 ## Increment the delay on enemy spawning
			else:
				i.spawnDelayCounter = 0 ## Reset delay counter
				var new_enemy = load(str(i.enemy.resource_path)) ## Gets the resource path of the enemy
				var counter = 0
				while counter < i.enemyNum: ## While the counter is less than the number of enemies we want to spawn
					var enemySpawn = new_enemy.instantiate() ## Creates instance of new enemy
					enemySpawn.global_position = getRandomPosition()
					add_child(enemySpawn)
					counter += 1

func getRandomPosition():
	var viewPortRect = get_viewport_rect().size * randf_range(1.1,1.4) ## Gets the size of the screen but slightly larger
	var topLeft = Vector2(player.global_position.x - viewPortRect.x/2, player.global_position.y - viewPortRect.y/2) ## Calculates top left
	var topRight = Vector2(player.global_position.x + viewPortRect.x/2, player.global_position.y - viewPortRect.y/2) ## Calculates top right
	var bottomLeft = Vector2(player.global_position.x - viewPortRect.x/2, player.global_position.y + viewPortRect.y/2) ## Calculates bottom left
	var bottomRight = Vector2(player.global_position.x + viewPortRect.x/2, player.global_position.y + viewPortRect.y/2) ## Calculates bottom right
	var posSide = ["up", "down", "left", "right"].pick_random() ## Picks a random value in array and sets to posSide
	var spawnPos1 = Vector2.ZERO
	var spawnPos2 = Vector2.ZERO
	
	match posSide:
		"up":
			spawnPos1 = topLeft
			spawnPos2 = topRight
		"down":
			spawnPos1 = bottomLeft
			spawnPos2 = bottomRight
		"right":
			spawnPos1 = topRight
			spawnPos2 = bottomRight
		"left":
			spawnPos1 = topLeft
			spawnPos2 = bottomRight
	
	var xSpawn = randf_range(spawnPos1.x, spawnPos2.x) ## Random spawn location between the two points on x axis
	var ySpawn = randf_range(spawnPos1.y, spawnPos2.y) ## Random spawn location between the two points on y axis
	return Vector2(xSpawn, ySpawn)
