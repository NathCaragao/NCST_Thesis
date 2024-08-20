extends CanvasLayer

func _ready():
	%PanelContainer.hide()

func showMessage(message: String, timeToShow: float) -> void :
	%Message.text = message
	%PanelContainer.show()
	await get_tree().create_timer(timeToShow).timeout
	%Message.text = ""
	%PanelContainer.hide()
