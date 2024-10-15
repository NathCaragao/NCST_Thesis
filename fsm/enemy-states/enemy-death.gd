class_name EnemyDeath
extends State

# references and variables
@export var actor : EnemyWolf
@onready var enemy_health_comp: EnemyHealthComp = $"../../EnemyHealthComp"
@onready var body_collision: CollisionShape2D = $"../../BodyCollision"


func enter() -> void:
	print("Enemy Entered Death State")
	# plays the death animation
	actor.animation_player.play("wolf-dead")
	
	
	# disable all phyics interactions
	body_collision.set_deferred("disabled", true)
	actor.hurt_box_shape.set_deferred("disabled", true)
	actor.hurt_box_shape.set_deferred("monitoring", false)
	actor.hurt_box_shape.set_deferred("monitorable", false)
	
	# disable other processes
	actor.set_physics_process(false)
	actor.set_process_input(false)
	actor.set_collision_layer_value(1, false)
	actor.set_collision_mask_value(1, false)

func physics_update(delta: float) -> void:
	# do nothing we're dead
	pass


func exit() -> void:
	# no such thing as exiting, bro's dead already
	pass
