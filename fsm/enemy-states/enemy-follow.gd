class_name EnemyFollow
extends State

# references and variables
@export var actor : EnemyWolf
@export var move_speed : float = 20.0
@onready var enemy_health_comp: EnemyHealthComp = $"../../EnemyHealthComp"
var player : Hercules
var direction

# state machine ref
@onready var state_machine : StateMachine = get_parent()

func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_enemy_dead2"))

func enter() -> void:
	player = get_tree().get_first_node_in_group("Player")
	#enemy_health_comp.connect("EnemyDead", Callable(self, "on_enemy_dead"))

func physics_update(delta: float) -> void:
	if is_instance_valid(player) and is_instance_valid(actor):
		direction = player.global_position - actor.global_position
		
		# Set the y-component to 0 to restrict movement to the x-axis (horizontal only)
		direction.y = 0
	
	# Set the y-component to 0 to restrict movement to the x-axis (horizontal only)
	direction.y = 0
	
	if direction.length() > 25:
		actor.velocity = direction.normalized() * move_speed
		actor.move_and_slide()
		actor.animation_player.play("wolf-run")
	
	# flip sprite
	actor.flip_sprite()
	
	# transitions to idle based on condition
	if direction.length() > 110:
		Transitioned.emit(self, "enemywander")
	
	# transition to attack state
	if direction.length() <= 25:
		Transitioned.emit(self, "enemyattack")


# transitions to enemy death
func on_enemy_dead2() -> void:
	Transitioned.emit(self, "enemydeath")
	#actor.animation_player.stop()
	#state_machine.force_death_state()
