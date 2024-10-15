class_name EnemyWander
extends State

# references and variables
@export var actor : EnemyWolf
@export var move_speed : float = 10.0
var player : Hercules
var is_signal_connected : bool = false
var direction
# state machine ref
@onready var state_machine : StateMachine = get_parent()

var move_direction : Vector2
var wander_time : float

@onready var enemy_health_comp: EnemyHealthComp = $"../../EnemyHealthComp"

func randomize_wander() -> void:
	move_direction = Vector2(randf_range(-1, 1), 0).normalized()
	wander_time = randf_range(1, 2)


func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_enemy_dead1"))
	pass

func enter() -> void:
	randomize_wander()
	player = get_tree().get_first_node_in_group("Player")
	#enemy_health_comp.connect("EnemyDead", Callable(self, "on_enemy_dead"))

func update(delta: float) -> void:
	if wander_time > 0:
		wander_time -= delta
	
	else:
		randomize_wander()

func physics_update(delta: float) -> void:
	if is_instance_valid(player) and is_instance_valid(actor):
		direction = player.global_position - actor.global_position
		
		# Set the y-component to 0 to restrict movement to the x-axis (horizontal only)
		direction.y = 0
	
	if actor:
		actor.velocity = move_direction * move_speed
		actor.animation_player.play("wolf-run")
	if actor.velocity.x < 0:
		actor.sprite.flip_h = false
	else:
		actor.sprite.flip_h = true
	
	actor.move_and_slide()
	
	# transitions to enemy follow
	if direction.length() < 90:
		print("ENEMY is following the player")
		Transitioned.emit(self, "enemyfollow")

# transitions to enemy death
func on_enemy_dead1() -> void:
	Transitioned.emit(self, "enemydeath")
	#print("dead!!!!!!")
	#actor.animation_player.stop()
	#state_machine.force_death_state()
