extends CharacterBody2D

@export var movementSpeed = 20.0

@onready var player = get_tree().get_first_node_in_group("player") ## Gets the player node so the enemy knows what the player is
## onready gets the value after the node has loaded
func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position) ## Compares position of enemy to the player as a vector on a graph
	velocity = direction*movementSpeed ## Moves towards the player based on the direction
	move_and_slide() ## Tells Godot the enemy wants to move
