extends Node
class_name QuestManager

# For @ scene management :

@onready var available = $Available
@onready var completed = $Completed
@onready var started = $Started
@onready var attacked = $Attacked
 
# For @ save management :

var startedQuests : Array[int] 
var completedQuests : Array[int]
var availableQuests : Array[int]

func _ready() -> void:
	print("SYS >> Initializing Quest Manager.") # Just to make sure the damn thing loads, this is traumatic

func _get_available_quests() -> Array: 
	# Loop through all children of available quests and for each one
	# append them to the array.
	var availableArr : Array[Quest]
	for quest in available.get_children():
		print("QUEST >> Quest: [" + str(quest) + "] is available.")
		quest.connect("started", _start_quest)
		availableArr.append(quest.questID)
	return availableArr

func _find_available_quest(questID) -> Quest:
	var foundQuest : Quest
	for i in available.get_children():
		if i.questID == questID:
			foundQuest = i
	return foundQuest
 
func _find_started_quest(questID) -> Quest:
	var foundQuest : Quest
	for i in started.get_children():
		if i.questID == questID:
			foundQuest = i
	return foundQuest

func _start_quest(quest: Quest) -> void:
	var beginQuest : Quest = available.find_child(quest.name)
	available.remove_child(beginQuest)
	started.add_child(beginQuest)
	beginQuest._start()
	startedQuests.append(quest.questID)

func _on_quest_completed(quest : Quest) -> void:
	# Remove it from started and add it to completed.
	started.remove_child(quest)
	completed.add_child(quest)
	completedQuests.append(quest.questID)

func _on_quest_attacked(quest : Quest) -> void:
	var parent = quest.get_parent()
	parent.remove_child(quest)
	attacked.add_child(quest)

func _save() -> void:
	pass
	
