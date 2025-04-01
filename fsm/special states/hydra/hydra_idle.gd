class_name HydraIdle
extends State
@export var actor : CharacterBody2D
@export var enemy_health_comp : Node2D
func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "hydra_dead1"))
func enter() -> void:
	pass
func update(delta: float) -> void:
	pass
func physics_update(delta: float) -> void:
	actor.velocity.y += actor.gravity * delta
	if actor.velocity.x == 0:
		actor.play_animation("enemy-idle")
func _on_danger_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Transitioned.emit(self, "hydraattack")
func hydra_dead1() -> void:
	Transitioned.emit(self, "enemydeath")
