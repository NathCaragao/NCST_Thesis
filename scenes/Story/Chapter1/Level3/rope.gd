extends Area2D

@export var large_crate : RigidBody2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 2 # allows the hurtbox to detect hitbox

func _ready() -> void:
	connect("area_entered", Callable(self, "on_rope_hit"))
	
	# makes the box freeze at the rope initiallt
	if large_crate and large_crate is RigidBody2D:
		large_crate.freeze = true

func on_rope_hit(arrow_hitbox: Area2D) -> void:
	if arrow_hitbox == null:
		return
	
	
	if arrow_hitbox is ProjectileHitbox:
		print("The arrow hit the rope!")
		
		call_deferred("crate_fall")

func crate_fall() -> void:
	if large_crate and large_crate is RigidBody2D:
		large_crate.freeze = false # make the box fall
