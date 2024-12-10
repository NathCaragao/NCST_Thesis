class_name QuestActivator
extends Area2D

@export_category("Quest Information")
@export var quest_name : String
@export var description : String
@export var quest_quota : String

func _ready() -> void:
	collision_layer = 0
	collision_mask = 8 # value of the mask 4

func _on_body_entered(body: Node2D) -> void:
	# show the questbox
	QuestUi.get_node('CanvasLayer').show()
	
	# add quest
	QuestUi.add_quest(quest_name, description)
