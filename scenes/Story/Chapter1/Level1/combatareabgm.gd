extends Node2D
@onready var combat = $"../bgm/combat"


func _on_combat_body_entered(body):
	print("entered combat sone")
	if body.is_in_group("Player"):
		combat.play()


func _on_combat_body_exited(body):
	if body.is_in_group("Player"):
		combat.stop()
