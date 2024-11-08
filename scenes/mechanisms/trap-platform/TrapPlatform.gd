extends AnimatableBody2D
@export var delay_before_moving: float = 1.0  # Time delay before the platform moves
@export var animation_name: String = "move_platform"  # Name of the animation to play

#@onready var timer: Timer = $Timer
@onready var trapzone = $trapzone
#@onready var detection_area: Area2D = $DetectionArea


func _on_trap_body_entered(body):
	if body.is_in_group("Player"):
		trapzone.play("bulaga")


func _on_trap_body_exited(body):
	if body.is_in_group("Player"):
		trapzone.stop()
