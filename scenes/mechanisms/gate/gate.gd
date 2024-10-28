class_name Gate
extends Node2D

# references
@onready var gate_anim: AnimationPlayer = $GateAnim
@onready var interaction_area: InteractionArea = $InteractionArea
@export var key_1 : Area2D

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_use")
	

func on_use() -> void:
	if key_1.key == true:
		gate_anim.play("gate-open")
	else:
		pass
