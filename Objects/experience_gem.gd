extends Area2D

@export var experience = 1
var greenGem = preload("res://Textures/gemGreen.png")
var blueGem = preload("res://Textures/gemBlue.png")
var redGem = preload("res://Textures/gemRed.png")
var target = null
var speed = -0.8
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $soundCollected

func _ready():
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = blueGem
	else:
		sprite.texture = redGem

func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed) ## Move towards the player if there is a target
		speed += 2 * delta ## Changes the speed variable

func collect():
	sound.play() ## Plays the sound
	collision.call_deferred("set", "disabled", true) ## Disables the collision of the object
	sprite.visible = false ## Hides the sprite
	return experience ## Returns the amount of xp the gem was worth

func _on_sound_collected_finished() -> void:
	queue_free() ## Clears the sprite from the screen once the sound has finished
