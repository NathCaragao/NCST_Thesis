class_name HydraIdle
extends State

# references and variables
@export var actor : CharacterBody2D
@export var enemy_health_comp : Node2D

func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_enemy_dead4"))

func enter() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	# putting the gravity to the actor
	actor.velocity.y += actor.gravity * delta
	
	if actor.velocity.x == 0:
		actor.play_animation("enemy-idle")
	
	# transitions to other states
	

func _on_danger_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Transitioned.emit(self, "hydraattack")

func on_enemy_dead4() -> void:
	Transitioned.emit(self, "enemydeath")
	#actor.animation_player.stop()
	#state_machine.force_death_state()
