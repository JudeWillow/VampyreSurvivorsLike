extends Area2D

@export var damage = 1
@onready var collision = $CollisionShape2D
@onready var timer =  $DisableHitboxTimer

func tempDisable():
	collision.call_deferred("set","disabled",true) ## Disables the collision and starts the timer
	timer.start()


func _on_disable_hitbox_timer_timeout() -> void: ## When the timer fades
	collision.call_deferred("set","disabled",false) ## Reanble the collision
