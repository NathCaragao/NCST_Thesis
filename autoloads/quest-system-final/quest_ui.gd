# QuestUI.gd
extends Node

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var quest_box: ColorRect = $CanvasLayer/QuestBox
@onready var title: Label = $CanvasLayer/QuestBox/Title
@onready var desc: Label = $CanvasLayer/QuestBox/Desc
@onready var quota: Label = $CanvasLayer/QuestBox/Quota

# Animation settings
const SLIDE_DURATION = 0.7
const SLIDE_TRANSITION = Tween.TRANS_BACK
const SLIDE_EASE = Tween.EASE_OUT

func _ready() -> void:
	quest_box.visible = false

func add_quest(quest_name: String, quest_desc: String) -> void:
	title.text = quest_name
	desc.text = quest_desc

func show_quest_box() -> void:
	quest_box.visible = true

func hide_quest_box() -> void:
	quest_box.visible = false

func open_quest_box() -> void:
	# Create and run open tween
	var open_tween = create_tween()
	open_tween.tween_property(quest_box, "position", Vector2(1387, 132), SLIDE_DURATION)\
		.set_trans(SLIDE_TRANSITION)\
		.set_ease(SLIDE_EASE)
	quest_box.visible = true

func close_quest_box() -> void:
	# Create and run close tween
	var close_tween = create_tween()
	close_tween.tween_property(quest_box, "position", Vector2(1936, 132), SLIDE_DURATION)\
		.set_trans(SLIDE_TRANSITION)\
		.set_ease(SLIDE_EASE)
	close_tween.tween_callback(func(): quest_box.visible = false)

func transition_quest_box() -> void:
	# Create tween for closing the quest box
	var close_tween = create_tween()
	close_tween.tween_property(quest_box, "position", Vector2(1958, 224), SLIDE_DURATION / 2)\
		.set_trans(SLIDE_TRANSITION)\
		.set_ease(SLIDE_EASE)
	
	# Wait for a short delay before opening
	await close_tween.finished
	await get_tree().create_timer(0.5).timeout
	
	
	# Create tween for opening the quest box again
	var open_tween = create_tween()
	open_tween.tween_property(quest_box, "position", Vector2(1387, 224), SLIDE_DURATION / 2)\
		.set_trans(SLIDE_TRANSITION)\
		.set_ease(SLIDE_EASE)
	open_tween.tween_callback(func(): 
		quest_box.visible = true
	)
