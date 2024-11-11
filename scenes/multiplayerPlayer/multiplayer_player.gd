class_name MultiplayerPlayer
extends Node2D


var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_speed = 200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	print_debug(Input.get_axis("move_left", "move_right"))
	
	# Set gravity to affect the body
	self.velocity.y += gravity * delta
	
	# Get the direction velocity
	var randomDirection = Vector2(randf_range(-1, 1), 0).normalized()
	
	# Set the speed velocity
	var movement = randomDirection * move_speed
	
	# Set and execute movement
	self.velocity.x = movement.x
	$".".move_and_slide()
