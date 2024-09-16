extends CanvasLayer

@onready var isShowing : bool = false

func _ready() -> void:
	$".".hide()

func showMessage(message: String, timeToShow: float) -> void :
	if not isShowing:
		isShowing = true
		%Message.text = message
		$".".show()
		await get_tree().create_timer(timeToShow).timeout
		%Message.text = ""
		$".".hide()
		isShowing = false
	elif isShowing:
		%Message.text = message
