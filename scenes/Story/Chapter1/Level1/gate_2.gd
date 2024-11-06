extends Node2D

@export var key_3 : Area2D
@onready var interaction_area: InteractionArea = $InteractionArea
@export var totem_holder: Node2D

var gate_zone : bool = false

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_key2_use")

func on_key2_use() -> void:
	if key_3.key_taken == true:
		if gate_zone == true:
			totem_holder.activate_totem()
			$GateAnim.play("gate-open")


func _on_interaction_area_body_entered(body: Node2D) -> void:
	gate_zone = true


func _on_interaction_area_body_exited(body: Node2D) -> void:
	gate_zone = false
