class_name QuestManager
extends Node2D

# Quest Box UI data
@onready var quest_box: CanvasLayer = GameUi.get_node('QuestBox')
@onready var quest_title: Label = GameUi.get_node('QuestBox').get_node('QuestTitle')
@onready var quest_desc: Label = GameUi.get_node('QuestBox').get_node('QuestDesc')
@onready var quota_count : Label = GameUi.get_node('QuestBox').get_node('QuotaCount')
# group export
@export_group("Quest Settings")
@export var quest_name : String # name of the quest
@export var quest_description : String # description of the quest
@export var quota_desc : String # for other types of quest
@export var reached_goal_text : String # description after completing quest

# Quests statuses
enum QuestStatus {
	available,
	started,
	reached_goal,
	finished,
}

# quest status variable
@export var quest_status : QuestStatus = QuestStatus.available

@export_group("Reward Settings")
@export var reward_amount : int # gold currency
