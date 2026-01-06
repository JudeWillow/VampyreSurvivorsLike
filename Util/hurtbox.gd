extends Area2D

@export_enum ("Cooldown", "HitOnce", "DisableHitbox") var HurtBoxType = 0
@onready var collision = $CollisionShape2D
@onready var timer = $DisableHurtboxTimer

signal hurt(damage) ## Creates a new signal "hurt" which lets us interact with player and enemy nodes



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Attack"): ## Checks for an area in the group attack
		if not area.get("damage") == null: ## Checks if it has a damage variable
			match HurtBoxType: ## Check the hurtboxtype, which we created at the beginning of the node
				0: ## Cooldown
					collision.call_deferred("set","disabled", true) ## Disable hurtbox collision so whatever is being hit doesnt get killed super fast
					timer.start() ## Start the timer
				1: ## HitOnce
					pass
				2: ##Disable Hitbox
					if area.has_method("tempDisable"): ## Check if the area of collision has tempDisable
						area.tempDisable() ## Call the tempDisable function, which disables the collision and starts the timer
			var damage = area.damage ## Damage variable based on the damage of the area
			emit_signal("hurt",damage) ## Emits the hurt signal which can interact with the player and enemy nodes to reduce their hp by the damage


func _on_disable_timer_timeout() -> void: ## Once the timer finishes, this function runs
	collision.call_deferred("set","disabled", false) ## Renable the ability for the collision detection to run
