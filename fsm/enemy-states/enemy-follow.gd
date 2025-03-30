class_name EnemyFollow
extends State

@export var actor : CharacterBody2D
@export var move_speed : float = 20.0
@export var enemy_health_comp : Node2D
@onready var player = get_tree().get_nodes_in_group("Player")
var direction

@export var direction_val : int = 35


func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_enemy_dead2"))

func enter() -> void:
	pass

func find_valid_player() -> Node2D:
	for player in player:
		if is_instance_valid(player):
			return player
	return null

func physics_update(delta: float) -> void:
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta
	
	var player = find_valid_player()
	
	if is_instance_valid(player) and is_instance_valid(actor):
		direction = player.global_position - actor.global_position
		
		direction.y = 0
	
	direction.y = 0
	
	if direction.length() > 25:
		actor.velocity = direction.normalized() * move_speed
		actor.move_and_slide()
		actor.play_animation("enemy-run")
	
	actor.flip_sprite()

	if direction.length() > 110:
		Transitioned.emit(self, "enemywander")
	

	if direction.length() <= direction_val:
		Transitioned.emit(self, "enemyattack")



func on_enemy_dead2() -> void:
	Transitioned.emit(self, "enemydeath")
	#actor.animation_player.stop()
	#state_machine.force_death_state()
