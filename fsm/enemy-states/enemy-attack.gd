class_name EnemyAttack
extends State

# references and variables
@export var actor : CharacterBody2D
@export var move_speed : float = 20.0

@export var enemy_health_comp : Node2D
@export var timer : Timer
var player : PlayerHercules
var direction

# state machine ref
#@onready var state_machine : StateMachine = get_parent()


func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_enemy_dead3"))

func enter() -> void:
	print("Entered attack state")
	player = get_tree().get_first_node_in_group("Player")
	#enemy_health_comp.connect("EnemyDead", Callable(self, "on_enemy_dead"))
	
	direction = player.global_position - actor.global_position
	
	if direction.length() <= 25:
		actor.animation_player.play("enemy-attack")
		timer.start()

func physics_update(delta: float) -> void:
	if is_instance_valid(player) and is_instance_valid(actor):
		direction = player.global_position - actor.global_position
		
		# Set the y-component to 0 to restrict movement to the x-axis (horizontal only)
		direction.y = 0
	
	# Set the y-component to 0 to restrict movement to the x-axis (horizontal only)
	direction.y = 0
	
	
	if direction.length() > 25:
		Transitioned.emit(self, "enemyfollow")
	elif direction.length() > 110:
		Transitioned.emit(self, "enemywander")

# transitions to enemy death
func on_enemy_dead3() -> void:
	timer.stop()
	Transitioned.emit(self, "enemydeath")
	#actor.animation_player.stop()
	#state_machine.force_death_state()

func on_hit1() -> void:
	Transitioned.emit(self, "enemyhit")

func _on_timer_timeout() -> void:
	actor.animation_player.play("enemy-attack")

func exit() -> void:
	pass
