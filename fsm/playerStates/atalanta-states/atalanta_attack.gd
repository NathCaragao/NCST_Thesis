class_name AtalantaAttack
extends State
@export var actor : CharacterBody2D
@export var player_health_component: PlayerHpComp
@export var Sword_swing :  AudioStreamPlayer2D
@export var bow_sound : AudioStreamPlayer2D
var attack_index : int = 0
var attack_animations : Array = ["attack1"]
var is_attacking : bool = false
@onready var arrow = load("res://scenes/mechanisms/arrow/arrow.tscn") as PackedScene
var bow_cooldown : bool = true
var attackCooldown = 0.5
func enter() -> void:
	print("Entered attack state")
	bow_sound.play()
	bow_attack()
func physics_update(delta: float) -> void:
	var movement
	if actor.playerGameData.isControlled:
		actor.velocity.y += actor.gravity * delta
		movement = Input.get_axis("move_left", "move_right") * actor.move_speed
	else:
		actor.velocity.y = actor.playerGameData.velocity.y
		movement = actor.playerGameData.velocity.x
	if !actor.animation_player.current_animation.begins_with("attack"):
		actor.velocity.x = movement
	actor._flip_sprite()
	actor.move_and_slide()
	if actor.animation_player.is_playing() and (actor.animation_player.current_animation.begins_with("attack") or actor.animation_player.current_animation.begins_with("player-shoot")):
		actor.playerGameData.isAttacking = true
		return
	if attackCooldown > 0:
		actor.playerGameData.isAttacking = false
		attackCooldown -= delta
		return
	actor.playerGameData.isAttacking = false
	if actor.playerGameData.isControlled:
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			Transitioned.emit(self, "atalantarun")
		if Input.is_action_just_pressed("jump"):
			Transitioned.emit(self, "atalantajump")
		if Input.is_action_just_pressed("skill"):
			Transitioned.emit(self, "atalantaskill")
	else:
		if actor.playerGameData.velocity.x != 0:
			Transitioned.emit(self, "atalantarun")
		if actor.playerGameData.isJumping:
			Transitioned.emit(self, "atalantajump")
		if actor.playerGameData.isSkill:
			Transitioned.emit(self, "atalantaskill")
	if player_health_component.current_health == 0:
		Transitioned.emit(self, "atalantadeath")
	Transitioned.emit(self, "atalantaidle")
func bow_attack() -> void:
	print("Entered bow_attack state")
	actor.velocity.x = 0
	actor.animation_player.play("attack1")
	if not actor.animation_player.animation_finished.is_connected(Callable(self, "_on_animation_finished")):
		actor.animation_player.animation_finished.connect(Callable(self, "_on_animation_finished"))
func arrow_fire() -> void:
	var arrow_instance = arrow.instantiate()
	arrow_instance.global_position.x = $"../../ArrowPos/ArrowSpawn".global_position.x + (40 * actor.playerGameData.direction)
	arrow_instance.global_position.y = $"../../ArrowPos/ArrowSpawn".global_position.y
	arrow_instance.vel = $"../../ArrowPos".scale.x
	if actor.playerGameData.direction < 0:
		arrow_instance.flip_sprite(true)
	get_parent().add_child(arrow_instance)
func _on_animation_finished(animation_name: String) -> void:
	actor.animation_player.play("idle")
	if animation_name == "attack":
		attackCooldown = float(10.0/60.0)
	arrow_fire()
func exit() -> void:
	actor.velocity = Vector2.ZERO
	actor.animation_player.animation_finished.disconnect(_on_animation_finished)
func update_animation(movement):
	if actor.animation_player.current_animation.begins_with("attack") or actor.animation_player.current_animation.begins_with("player-shoot"):
		if not actor.animation_player.is_playing():
			actor.animation_player.stop()
		else:
			return
