extends CharacterBody2D

@export var hp = 10
@export var movementSpeed = 20.0
@onready var sprite = $Sprite2D
@onready var anim = $Walk
@onready var player = get_tree().get_first_node_in_group("player") ## Gets the player node so the enemy knows what the player is
@onready var lootBase = get_tree().get_first_node_in_group("Loot")
@export var exp = 1
var expGem = preload("res://Objects/experience_gem.tscn")

func _ready(): ## Runs once when the program starts
	anim.play("Walk") ##Plays the walking animation
## onready gets the value after the node has loaded
func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position) ## Compares position of enemy to the player as a vector on a graph
	velocity = direction*movementSpeed ## Moves towards the player based on the direction
	move_and_slide() ## Tells Godot the enemy wants to move
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < -0:
		sprite.flip_h = false


func _on_hurtbox_hurt(damage: Variant) -> void:
	hp -= damage
	if hp <= 0:
		queue_free() ## Deletes the enemy if its hp reaches 0
		var newGem = expGem.instantiate()
		newGem.global_position = global_position 
		newGem.experience = exp
		lootBase.call_deferred("add_child", newGem)
