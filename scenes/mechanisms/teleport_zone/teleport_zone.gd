class_name TeleportZone
extends Area2D

@export var playerToTeleport: CharacterBody2D
@onready var marker_2d: Marker2D = $Marker2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, CharacterBody2D):
		if body.playerGameData.playerId == playerToTeleport.playerGameData.playerId:
			playerToTeleport.position = marker_2d.position
