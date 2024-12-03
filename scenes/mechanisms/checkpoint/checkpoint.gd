class_name Checkpoint
extends Area2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var spawn_point = %SpawnPoint
@export var fail_screen : Control
@export var player_node : CharacterBody2D

var checkpoint_reached: bool = false

func _ready():
	# Ensure spawn point exists
	if not spawn_point:
		print("WARNING: No spawn point found!")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		checkpoint_reached = true
		print("Checkpoint reached!")
		$"../ScoreUI/FailScreen/VBoxContainer/RespawnBtn".disabled = false

func respawn_player() -> void:
	fail_screen.visible = false
	
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	player_revive()
	
	GameSignals.emit_signal("playerrespawn")

# Optional method to be called when player dies
#func trigger_respawn() -> void:
	#respawn_player()

func player_revive() -> void:
	# Check if player and spawn point exist
	if player_node and spawn_point and checkpoint_reached:
		# Reset player's global position to spawn point
		player_node.global_position = spawn_point.global_position
		
		# Reset player health
		var player_hp_component = player.get_node_or_null("PlayerHealthComponent")
		if player_hp_component:
			player_hp_component.reset_health()
		
		 #Reset animation
		var animation_player = player.get_node_or_null("AnimationPlayer")
		if animation_player:
			# Play idle or default animation
			animation_player.play("idle")  # Use your default animation name
		
		player_node.hurtbox_collision.set_deferred("disabled", false)
		
		# Optional: Additional revival logic
		player_node.set_physics_process(true)  # Re-enable physics
		player_node.set_process(true)  # Re-enable processing
		player_node.set_collision_layer_value(1, true)
		player_node.set_process_input(true) # Re-enable input
		player_node.set_collision_mask_value(1, true)
