class_name TeleportZone
extends Area2D
@export var playerToTeleport: CharacterBody2D
@onready var marker_2d: Marker2D = $Marker2D
func _ready() -> void:
	pass 
func _process(delta: float) -> void:
	pass
func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, CharacterBody2D):
		if body.playerGameData.playerId == playerToTeleport.playerGameData.playerId:
			playerToTeleport.position = marker_2d.position
