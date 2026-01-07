extends Area2D

@export var experience = 1
var greenGem = preload("res://Textures/gemGreen.png")
var blueGem = preload("res://Textures/gemBlue.png")
var redGem = preload("res://Textures/gemRed.png")
var target = null
var speed = 0
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready():
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = blueGem
	else:
		sprite.texture = redGem

func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2 * delta

func collect():
	queue_free()
	return experience
