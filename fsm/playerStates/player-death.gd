class_name PlayerDeath
extends State
@export var actor : CharacterBody2D
@export var death : AudioStreamPlayer2D
func _ready() -> void:
	GameSignals.connect("playerrespawn", Callable(self, "on_player_respawn"))
func enter() -> void:
	print("PLAYER DIED")
	actor.animation_player.play("player-dead")
	death.play()
	$"../../PlayerHealthComponent/Hurtbox/HurtboxCollision".set_deferred("disabled", true)
	actor.set_physics_process(false)
	actor.set_process_input(false)
	actor.set_collision_layer_value(1, false)
	actor.set_collision_mask_value(1, false)
func physics_update(delta: float) -> void:
	pass
func on_player_respawn() -> void:
	Transitioned.emit(self, "playeridle")
func exit() -> void:
	pass
