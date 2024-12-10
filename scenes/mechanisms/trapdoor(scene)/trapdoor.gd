extends StaticBody2D

@onready var close: Sprite2D = $Close
@onready var open: Sprite2D = $Open
@onready var collision: CollisionShape2D = $CollisionShape2D

@export var cyclops : Megalus

func _ready() -> void:
	GameSignals.connect("MegalusDefeated", Callable(self, "on_cyclops_defeat"))
	sprite_close()

func sprite_open() -> void:
	close.visible = false
	open.visible = true
	collision.disabled = true

func sprite_close() -> void:
	if cyclops:
		close.visible = true
		open.visible = false
		collision.disabled = false

func on_cyclops_defeat() -> void:
	sprite_open()
	QuestUi.transition_quest_box()
	QuestUi.add_quest("The Lion's Den", "Continue exploring underground")
