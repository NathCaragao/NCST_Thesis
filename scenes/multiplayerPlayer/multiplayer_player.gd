class_name MultiplayerPlayer
extends Node2D



var playerId: String = ""

@export var movementSpeed = 200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1  # 0 being default from Input.get_axis()
var state


func updatePlayer(newPlayerInformation):
	pass

func _ready() -> void:
	$Camera2D.enabled = false  # If you are to convert this to be the new implementation
	pass

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	_movePlayer(Vector2(0,0), 100.0, delta)
	_flipSprite()

func _movePlayer(moveDirection: Vector2, moveSpeed: float, delta):
	$".".velocity.y += self.gravity * delta
	var movementVector = moveDirection.normalized() * moveSpeed
	
	$".".velocity.x = movementVector.x
	$".".move_and_slide()

func _flipSprite() -> void:
	if direction > 0:
		%Sprite.flip_h = false
	elif direction < 0:
		%Sprite.flip_h = true
	
	#if direction == 1:
		#$ArrowPos.scale.x = 1
	#elif direction == -1:
		#$ArrowPos.scale.x = -1
