class_name HydraAttack
extends State

# references
@export var actor : CharacterBody2D
@export var timer : Timer

# poison projectile reference
@export var poison = load("res://scenes/mechanisms/poison-projectile/poison.tscn") as PackedScene
@onready var player = get_tree().get_first_node_in_group("Player")

func enter() -> void:
	print("Entered Hydra attack state")
	actor.play_animation("enemy-attack")
	await actor.animation_player.animation_finished
	poison_shoot()
	timer.start()



func _on_danger_area_body_exited(body: Node2D) -> void:
	Transitioned.emit(self, "hydraidle")


func _on_timer_timeout() -> void:
	actor.play_animation("enemy-attack")
	await actor.animation_player.animation_finished
	poison_shoot()

func poison_shoot() -> void:
	# instantiate the poison
	var poison_instance = poison.instantiate()
	
	 # Instead of just setting vel, we'll set the initial direction
	var direction_to_player = poison_instance.global_position.direction_to(
	player.global_position)
	
	poison_instance.global_position = $"../../PoisonPos/PoisonSpawn".global_position
	poison_instance.vel = $"../../PoisonPos".scale.x
	get_parent().call_deferred("add_child", poison_instance)
	print("Shooting Poison...")
