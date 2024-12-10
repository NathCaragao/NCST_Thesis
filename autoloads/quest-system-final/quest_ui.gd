# QuestUI.gd
extends Control

@onready var quest_box: ColorRect = $CanvasLayer/QuestBox
@onready var title: Label = $CanvasLayer/QuestBox/Title
@onready var desc: Label = $CanvasLayer/QuestBox/Desc
@onready var quota: Label = $CanvasLayer/QuestBox/Quota


func add_quest(quest_name: String, quest_desc: String) -> void:
	title.text = quest_name
	desc.text = quest_desc

func show_quest_box() -> void:
	quest_box.visible = true

func hide_quest_box() -> void:
	quest_box.visible = false
