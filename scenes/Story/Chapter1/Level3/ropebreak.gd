extends AnimatableBody2D
@onready var joint = $PinJoint2D
@onready var sprite_2d = $Sprite2D
# Function to break the rope
func  break_rope():
	joint.queue_free()
	sprite_2d.queue_free()
	$Area2D.queue_free()
	$CollisionShape2D.queue_free()


func _init() -> void:
	collision_layer = 0
	collision_mask = 2 # allows the hurtbox to detect hitbox

func _ready() -> void:
	connect("area_entered", Callable(self, "on_rope_hit"))


func on_rope_hit(arrow_hitbox: Area2D) -> void:
	if arrow_hitbox == null:
		return
	
	
	if arrow_hitbox is ProjectileHitbox:
		_on_hit()


func _on_hit():
	break_rope()
