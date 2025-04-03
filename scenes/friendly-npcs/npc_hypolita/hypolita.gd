extends CharacterBody2D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
func _ready() -> void:
	animated_sprite.flip_h = true
func _process(delta: float) -> void:
	look_at_player()
func look_at_player() -> void:
	if player == null:
		return
	var direction_to_player = player.global_position - global_position
	if direction_to_player.x < 0:
		animated_sprite.flip_h = true
	elif direction_to_player.x > 0:
		animated_sprite.flip_h = false
