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
	_movePlayer(Vector2(0,0), 100.0, delta)

func _movePlayer(moveDirection: Vector2, moveSpeed: float, delta):
	# Set gravity to affect the body
	$".".velocity.y += gravity * delta
	
	# Set the speed velocity
	var movementVector = moveDirection.normalized() * moveSpeed
	
	# Set and execute movement
	$".".velocity.x = movementVector.x
	$".".move_and_slide()
