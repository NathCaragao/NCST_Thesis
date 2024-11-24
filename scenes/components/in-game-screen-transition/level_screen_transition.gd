extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal on_transition_finished

func _ready() -> void:
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)

func transition() -> void:
	color_rect.visible = true
	animation_player.play("fade-to-black")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "fade-to-black":
		on_transition_finished.emit()
		animation_player.play("fade-to-normal")
	elif anim_name == "fade-to-normal":
		color_rect.visible = false
