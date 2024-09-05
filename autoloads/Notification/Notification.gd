extends CanvasLayer

var isShowing : bool = false

func _ready():
	%PanelContainer.hide()

func showMessage(message: String, timeToShow: float) -> void :
	if not isShowing:
		isShowing = true
		%Message.text = message
		%PanelContainer.show()
		await get_tree().create_timer(timeToShow).timeout
		%Message.text = ""
		%PanelContainer.hide()
		isShowing = false
	elif isShowing:
		%Message.text = message
