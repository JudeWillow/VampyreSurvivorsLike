extends CharacterBody2D

var movementSpeed = 80.0
@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%WalkTimer")

func _physics_process(_delta): ## Runs every physics game tick (1/60 of a second)
	movement()

func movement():
	var xMove = Input.get_action_strength("right") - Input.get_action_strength("left") ## Calculates input and will return 0 if both keys are pressed
	var yMove = Input.get_action_strength("down") - Input.get_action_strength("up") ## Calculates input and will return 0 if both keys are pressed
	var move = Vector2(xMove, yMove) ## Uses inputs from xMove and yMove to create a vector, telling the program in which direction the character will need to move based on a graph vector
	if move.x > 0:
		sprite.flip_h = true
	elif move.x < 0:
		sprite.flip_h = false
	
	if move != Vector2.ZERO:
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	velocity = move.normalized() * movementSpeed ## Creates a velocity by using the base velocity set at the start and the direction pressed
	##Using the .normalized function allows the player to not move much faster in a diagonal than other directions
	move_and_slide()##Tells Godot the character wants to move
