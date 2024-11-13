extends PathFollow2D

@onready var rabbit: CharacterBody2D = $Rabbit

var player_entered : bool = false

func _process(delta: float) -> void:
	rabbit_run(delta)


func _on_p_1_area_body_entered(body: Node2D) -> void:
	if player_entered == false:
		player_entered = true
		rabbit.rabbit_appear()
	else:
		print("Player already entered the scene!")


func _on_p_1_exit_body_entered(body: Node2D) -> void:
	rabbit.rabbit_hide()
	player_entered = true

func rabbit_run(delta: float) -> void:
	if player_entered == true:
		progress_ratio += delta * rabbit.speed
		rabbit.animated_sprite.play("rabbit-run")
