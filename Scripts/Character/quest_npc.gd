extends Node
class_name Quest_NPC

@warning_ignore("unused_signal")
signal interaction

@export var connectedQuest : Quest
@onready var availableQuests = Quest_Manager.available
@onready var completedQuests = Quest_Manager.completed

@export var killIfCompleted : bool = false

var finishedDialogue: bool = false
var dialogue : DialogueScript

func _ready() -> void:
	var questID
			
	# Snap the NPC to the grid

	self.global_position = self.position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	@warning_ignore("integer_division")
	self.global_position -= Vector2.ONE * (Constants.TILE_SIZE / 2)

	# On launch, check that reference to QuestManager attributes are correct.
	# Check for if the quest is correct.
	# If not, kill the NPC.

	if connectedQuest != null:
		questID = connectedQuest.questID
		connectedQuest.connectedNpc = self

		if Quest_Manager.availableQuests.has(connectedQuest.questID):
			connectedQuest.queue_free()
			connectedQuest = Quest_Manager._find_available_quest(questID)
			connectedQuest.connectedNpc = self
			return

		elif Quest_Manager.startedQuests.has(connectedQuest.questID):
			connectedQuest = Quest_Manager._find_started_quest(questID)
			return

		elif Quest_Manager.completedQuests.has(connectedQuest.questID):
			connectedQuest.queue_free()
			connectedQuest.connectedNpc = self
			return
		connectedQuest._connect_to_npc(self)


func _interact() -> void:
	
	if connectedQuest == null || finishedDialogue == true:
		dialogue = $FinishedDialogue
		Constants.UI._write_to_screen(dialogue._read_dialogue(), self.name)
		return
	elif _does_player_meet_requirements() == true:
			if Quest_Manager.availableQuests.has(connectedQuest.questID):
				connectedQuest._start()
				connectedQuest._run_quest_dialogue()
			else:
				connectedQuest._run_quest_dialogue()

func _does_player_meet_requirements() -> bool:
	if connectedQuest.questAvailable == false && _check_start_requirements().size() != connectedQuest.startRequirements.size():
		return false
	else:
		return true

func _check_start_requirements() -> Array:
	var reqArr : Array
	for i in completedQuests.get_children():
		if connectedQuest.startRequirements.find(i.questID) != null:
			reqArr.append(i.questID)
	return reqArr

func _attacked() -> void:
	pass
