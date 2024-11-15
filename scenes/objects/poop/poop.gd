extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var cleaned : bool = false

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_cleanup")

func on_cleanup() -> void:
	if not cleaned:
		visible = false
		cleaned = true
		$InteractionArea/CollisionShape2D.queue_free()
		print("shit cleaned up!")
