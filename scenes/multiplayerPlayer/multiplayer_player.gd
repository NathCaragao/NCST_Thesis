class_name MultiplayerPlayer
extends Node2D


# Movement related stuff
@export var movementSpeed = 200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0  # 0 being default from Input.get_axis()
var playerId: String = ""

# Visual related stuff
#@export var characterSprite: PackedScene
	

func updatePlayer(newPlayerInformation):
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera2D.enabled = false  # If you are to convert this to be the new implementation
	# of Player node, make a function to enable/disable this based on condition.
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	_movePlayer(Vector2(0,0), 100.0, delta)
	_flipSprite()

func _movePlayer(moveDirection: Vector2, moveSpeed: float, delta):
	# Set gravity to affect the body
	$".".velocity.y += self.gravity * delta
	
	# Set the speed velocity
	var movementVector = moveDirection.normalized() * moveSpeed
	
	# Set and execute movement
	$".".velocity.x = movementVector.x
	$".".move_and_slide()

func _flipSprite() -> void:
	if direction > 0:
		%Sprite.flip_h = false
		#$PlayerHealthComponent/Hitbox/CollisionShape2D.position.x = 19
		#$PlayerHealthComponent/SkillHitbox/CollisionShape2D.position.x = 27.75
	elif direction < 0:
		%Sprite.flip_h = true
		#$PlayerHealthComponent/Hitbox/CollisionShape2D.position.x = -19
		#$PlayerHealthComponent/SkillHitbox/CollisionShape2D.position.x = -27.75
	
	#if direction == 1:
		#$ArrowPos.scale.x = 1
	#elif direction == -1:
		#$ArrowPos.scale.x = -1
