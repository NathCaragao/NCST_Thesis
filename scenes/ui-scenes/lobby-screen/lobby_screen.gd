extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var result = await ServerManager.connectSocketToServerAsync()
	
	if result == OK:
		print_debug("Successfully connected to the socket")
	else:
		print_debug("ERROR connecting to the socket")
	pass # Replace with function body.

	await ServerManager.createMatch()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
