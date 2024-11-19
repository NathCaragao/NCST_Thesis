class_name HydraAttack
extends State

@export var actor: CharacterBody2D
@export var timer: Timer
var poison = load("res://scenes/mechanisms/poison-projectile/poison.tscn") as PackedScene
@onready var player = get_tree().get_first_node_in_group("Player")
@export var enemy_health_comp : Node2D

# Pattern variables
@export var shots_per_burst: int = 3  # How many poisons to shoot in one burst
@export var time_between_shots: float = 1.5  # Time between each poison in a burst
@export var vulnerability_time: float = 2.5  # How long the boss is vulnerable after shooting
@export var burst_delay: float = 0.1  # Small delay between animation and shooting
var is_active : bool = true

var shots_fired: int = 0
var is_vulnerable: bool = false

func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_enemy_dead3"))

func enter() -> void:
	print("Entered Hydra attack state")
	is_active = true
	if is_active:
		start_attack_sequence()

func start_attack_sequence() -> void:
	shots_fired = 0
	actor.play_animation("enemy-attack")
	await actor.animation_player.animation_finished
	await get_tree().create_timer(burst_delay).timeout
	if is_active:
		shoot_burst()

func shoot_burst() -> void:
	while shots_fired < shots_per_burst:
		actor.play_animation("enemy-attack")
		poison_shoot()
		shots_fired += 1
		if shots_fired < shots_per_burst:
			await get_tree().create_timer(time_between_shots).timeout
	
	# After burst is complete, enter vulnerable state
	enter_vulnerable_state()

func enter_vulnerable_state() -> void:
	is_vulnerable = true
	print("Boss is vulnerable!")
	# Here you could play a vulnerable animation or change the boss's state
	actor.play_animation("enemy-idle")  # If you have this animation
	
	# Wait for vulnerability period to end
	await get_tree().create_timer(vulnerability_time).timeout
	end_vulnerable_state()

func end_vulnerable_state() -> void:
	is_vulnerable = false
	print("Boss is no longer vulnerable!")
	# Start the next attack sequence
	start_attack_sequence()

func _on_danger_area_body_exited(body: Node2D) -> void:
	if not is_vulnerable:
		Transitioned.emit(self, "hydraidle")

func poison_shoot() -> void:
	var poison_instance = poison.instantiate()
	
	# Calculate direction to player
	#var direction_to_player = poison_instance.global_position.direction_to(
		#player.global_position
	#)
	
	poison_instance.global_position = $"../../PoisonPos/PoisonSpawn".global_position
	poison_instance.vel = $"../../PoisonPos".scale.x
	get_parent().call_deferred("add_child", poison_instance)
	print("Shooting Poison...")

# Optional: Add function to handle getting hit during vulnerable state
func take_damage(amount: int) -> void:
	if is_vulnerable:
		# Apply extra damage or specific effects when hit during vulnerable state
		print("Boss took", amount, "damage while vulnerable!")
	else:
		# Normal damage or no damage when not vulnerable
		print("Boss is not vulnerable!")


func on_enemy_dead3() -> void:
	is_active = false  # Stop further logic
	Transitioned.emit(self, "enemydeath")
