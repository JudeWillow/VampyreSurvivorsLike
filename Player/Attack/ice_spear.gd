extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knock = 100
var attackSize = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	match level:
		1:
			hp = 1
			speed = 100
			damage = 5
			knock = 100
			attackSize = 1.0
			
func _physics_process(delta: float) -> void:
	position += angle * speed * delta

func enemyHit(charge = 1):
	hp -= charge
	if hp <= 0:
		queue_free() ## Deletes ice spear if it reaches 0 hp (when it hits an enemy)

func _on_timer_timeout() -> void:
	queue_free() ## If spear misses target, will clear after 10s
