extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		animation_player.play("coin-pickup")
		ScoreManager.add_points("coin")
		print("+ 1")
