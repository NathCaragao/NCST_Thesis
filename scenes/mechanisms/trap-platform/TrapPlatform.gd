extends AnimatableBody2D
@export var delay_before_moving: float = 1.0 
@export var animation_name: String = "move_platform"  
@onready var trapzone = $trapzone
func _on_trap_body_entered(body):
	if body.is_in_group("Player"):
		trapzone.play("bulaga")
func _on_trap_body_exited(body):
	if body.is_in_group("Player"):
		trapzone.stop()
