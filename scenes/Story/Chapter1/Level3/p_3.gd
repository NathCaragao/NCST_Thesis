extends PathFollow2D
@onready var rabbit: CharacterBody2D = $Rabbit
var player_entered: bool = false
var rabbit_running: bool = false
func _process(delta: float) -> void:
	rabbit_run(delta)
	rabbit.move_and_slide()
func rabbit_run(delta: float) -> void:
	if player_entered == true:
		if rabbit_running == true:
			progress_ratio += delta * rabbit.speed
			rabbit.animated_sprite.play("rabbit-run")
func _on_p_3_area_3_body_entered(body: Node2D) -> void:
	if player_entered == false:
		player_entered = true
		rabbit_running = true
		rabbit.rabbit_appear()
	else:
		print("Player already entered the scene!")
func _on_p_3_exit_body_entered(body: Node2D) -> void:
	rabbit_running = false
	rabbit.animated_sprite.stop()
	rabbit.animated_sprite.play("rabbit-idle")
	rabbit.rabbit_hide()
