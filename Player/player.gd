extends CharacterBody2D

@export var hp = 80
var movementSpeed = 80.0
@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%WalkTimer")
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")
@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%IceSpearAttackTimer")
var iceSpearAmmo = 0
var iceSpearBaseAmmo = 1
var iceSpearAttackSpeed = 1.5
var iceSpearLevel = 1
var enemyClose = []
var experience = 0
var experienceLevel = 1
var collectedExperience = 0
@onready var EXPBar = get_node("%EXPBar")
@onready var labelLevel = get_node("%LabelLevel")

func _ready():
	attack()
	setEXPBar(experience, calculateExperienceCap())

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
	
	if move != Vector2.ZERO: ## If there is movement
		if walkTimer.is_stopped(): ## if the timer isnt running
			if sprite.frame >= sprite.hframes - 1: ## If we have already moved 1 frame of the animation
				sprite.frame = 0 ## Set the frame back to 0
			else:
				sprite.frame += 1 ## Increase the sprite animation frame by 1
			walkTimer.start() ## Starts the timer for the delay, so it wont loop the animation super fast
	velocity = move.normalized() * movementSpeed ## Creates a velocity by using the base velocity set at the start and the direction pressed
	##Using the .normalized function allows the player to not move much faster in a diagonal than other directions
	move_and_slide()##Tells Godot the character wants to move

func attack():
	if iceSpearLevel > 0:
		iceSpearTimer.wait_time = iceSpearAttackSpeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()

func _on_hurtbox_hurt(damage: Variant) -> void:
	hp -= damage
	print(hp)


func _on_ice_spear_timer_timeout() -> void:
	iceSpearAmmo += iceSpearBaseAmmo
	iceSpearAttackTimer.start()


func _on_ice_spear_attack_timer_timeout() -> void:
	if iceSpearAmmo > 0:
		var iceSpearAttack = iceSpear.instantiate()
		iceSpearAttack.position = position
		iceSpearAttack.target = getRandomTarget()
		iceSpearAttack.level = iceSpearLevel
		add_child(iceSpearAttack)
		iceSpearAmmo -= 1
		if iceSpearAmmo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()
		
func getRandomTarget():
	if enemyClose.size() > 0:
		return enemyClose.pick_random().global_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemyClose.has(body):
		enemyClose.append(body)


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemyClose.has(body):
		enemyClose.erase(body)


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Loot"): ## Checks if its in the loot group
		area.target = self ## Will target the player if it is

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Loot"): ## Check if its in the loot group
		var gemExp = area.collect() ## Returns the value from the xp gem using collect function
		calculateExperience(gemExp)

func calculateExperience(gemExp):
	var expReq = calculateExperienceCap()
	collectedExperience += gemExp
	if experience + collectedExperience >= expReq:
		collectedExperience -= expReq - experience
		experienceLevel += 1
		labelLevel.text = str("Level: ", experienceLevel)
		print("Level:", experienceLevel)
		experience = 0
		expReq = calculateExperienceCap()
		calculateExperience(0) ## When you level, it will run with however much is in collectedExperience again
	else:
		experience += collectedExperience
		collectedExperience = 0
	
	setEXPBar(experience, expReq)

func calculateExperienceCap():
	var expCap = experienceLevel
	if experienceLevel < 20:
		expCap = experienceLevel * 5
	elif experienceLevel < 40:
		expCap + 95 * (experienceLevel-19) * 8
	else:
		expCap = 255 + (experienceLevel - 39) * 12
	return expCap
 
func setEXPBar(setValue = 1, setMaxValue = 100):
	EXPBar.value = setValue
	EXPBar.max_value = setMaxValue
