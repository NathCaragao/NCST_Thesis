class_name Gate
extends Node2D

# references
@onready var gate_anim: AnimationPlayer = $GateAnim
@onready var interaction_area: InteractionArea = $InteractionArea
@export var key_1 : Area2D
var gate_zone : bool = false

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_use")
	

func on_use() -> void:
	if key_1.key_taken == true:
		if gate_zone == true:
			gate_anim.play("gate-open")
			$InteractionArea/CollisionShape2D.disabled = true
			print("gate opened!")


func _on_interaction_area_body_entered(body: Node2D) -> void:
	gate_zone = true
	print(gate_zone)


func _on_interaction_area_body_exited(body: Node2D) -> void:
	gate_zone = false
	print(gate_zone)
