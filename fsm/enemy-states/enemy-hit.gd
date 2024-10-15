class_name EnemyHit
extends State

# references and variables
@export var actor : EnemyWolf
@export var enemy_health : EnemyHealthComp
@export var attack : AttackComponent
@export var dmg_num : Label
@onready var player : Hercules = get_tree().get_first_node_in_group("Player")


var is_knocked_back: bool = false
var deceleration: float = 800.0

func _ready() -> void:
	enemy_health.connect("Hit", Callable(self, "on_hit"))

func enter() -> void:
	pass

func physics_update(delta: float) -> void:
	if is_knocked_back:
		# Decelerate the velocity
		actor.velocity.x = move_toward(actor.velocity.x, 0, deceleration * delta)

		# Apply the movement with deceleration
		actor.move_and_slide()

		# If velocity is very small, stop knockback
		if abs(actor.velocity.x) < 0.1:
			is_knocked_back = false
			actor.velocity = Vector2.ZERO

func on_hit() -> void:
	actor.animation_player.play("wolf-hit")
	print("Enemy got HIT")
	freeze_time(0.4, 0.15)
	knock_back()

func knock_back() -> void:
	# enemy knockback
	var knockback_direction = (actor.global_position - player.global_position).normalized()
	knockback_direction.y = 0 # ensure 0 to keep the knockback horizontal
	
	actor.velocity = knockback_direction * attack.knockback_force
	
	actor.move_and_slide()
	
	is_knocked_back = true

func freeze_time(timescale, duration) -> void:
	Engine.time_scale = timescale
	await(get_tree().create_timer(duration * timescale).timeout)
	Engine.time_scale = 1.0


func exit() -> void:
	is_knocked_back = false
