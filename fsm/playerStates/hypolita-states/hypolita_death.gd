class_name HypolitaDeath
extends State

# references
@export var actor : CharacterBody2D
@export var death : AudioStreamPlayer2D
func _ready() -> void:
	GameSignals.connect("playerrespawn", Callable(self, "on_player_respawn"))

func enter() -> void:
	print("PLAYER DIED")
	actor.animation_player.play("death")
	death.play()
	# disable all phyics interactions
	$"../../PlayerHealthComponent/Hurtbox/HurtboxCollision".set_deferred("disabled", true)
	
	# disable other processes
	actor.set_physics_process(false)
	actor.set_process_input(false)
	actor.set_collision_layer_value(1, false)
	actor.set_collision_mask_value(1, false)

func physics_update(delta: float) -> void:
	# do nothing we're dead
	pass

func on_player_respawn() -> void:
	Transitioned.emit(self, "playeridle")


func exit() -> void:
	# no such thing as exiting, bro's dead already
	pass
