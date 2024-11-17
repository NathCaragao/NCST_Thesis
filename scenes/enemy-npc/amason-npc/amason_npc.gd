extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	animated_sprite.flip_h = true

func _process(delta: float) -> void:
	look_at_player()

# npc flips sprite based on player's direction
func look_at_player() -> void:
	if player == null:
		return
	
	if player.direction > 0:
		animated_sprite.flip_h = false
	elif player.direction < 0:
		animated_sprite.flip_h = true
