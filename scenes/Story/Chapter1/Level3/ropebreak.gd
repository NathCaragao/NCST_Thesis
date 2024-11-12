extends AnimatableBody2D
@onready var joint = $PinJoint2D
@onready var sprite_2d = $Sprite2D
# Function to break the rope
func  break_rope():
	joint.queue_free()
	sprite_2d.queue_free()
	$Area2D.queue_free()
	$CollisionShape2D.queue_free()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_hit():
	break_rope()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		print("putol")
		_on_hit()
