extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_attacking : bool = false

func _physics_process(delta: float) -> void:
	# Handle attack first
	if Input.is_action_just_pressed("attack") and not is_attacking:
		start_attack()
		return  # Exit physics process to focus on attack animation
	
	# Skip movement and animations if attacking
	if is_attacking:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	update_animations(delta)
	flip_sprite()
	move_and_slide()

func update_animations(delta: float) -> void:
	# run and idle animation
	if is_on_floor():
		if velocity.x != 0:
			animation_player.play("atalanta-run")
		elif velocity.x == 0:
			animation_player.play("atalanta-idle")
	else:
		animation_player.play("atalanta-jump")

# flip sprite
func flip_sprite() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

func start_attack() -> void:
	is_attacking = true
	animation_player.play("atalanta-attack")
	
	await animation_player.animation_finished
	is_attacking = false
