class_name QuestManager
extends Node2D

@onready var quest_box: CanvasLayer = GameUi.get_node('QuestBox')
@onready var quest_title: Label = GameUi.get_node('QuestBox').get_node('QuestTitle')
@onready var quest_desc: Label = GameUi.get_node('QuestBox').get_node('QuestDesc')
@onready var quota_count : Label = GameUi.get_node('QuestBox').get_node('QuotaCount')

@export_group("Quest Settings")
@export var quest_name : String 
@export var quest_description : String 
@export var quota_desc : String 
@export var reached_goal_text : String 

enum QuestStatus {
	available,
	started,
	reached_goal,
	finished,
}

@export var quest_status : QuestStatus = QuestStatus.available

@export_group("Reward Settings")
@export var reward_amount : int 
