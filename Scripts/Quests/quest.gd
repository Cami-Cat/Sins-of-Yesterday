extends Node
class_name Quest

@warning_ignore("unused_signal")
signal completed()
@warning_ignore("unused_signal")
signal started(reference) # Reference to self
@warning_ignore("unused_signal")
signal delivered()

# Important references to the things that execute dialogue, 
# events and handles objectives before quest completion.

@onready var objectives = $Objectives
@onready var events = $Events
@onready var questDialogue = $Dialogue

@export var questID : int 
@export var startRequirements : Array[int] = [] # The IDs of quests this one requires
@export var startEvent : Event
@export var endEvent : Event

var questAvailable : bool = false
var npcName : String
var connectedNpc : Node

func _ready() -> void:
	events.connect("events_complete", _event_completion)
	if startRequirements.size() == 0:
		questAvailable = true
	else:
		questAvailable = false

func _start() -> void:
	for objective in _get_objectives():
		objective.connect("completed", _on_objective_completed)
	Quest_Manager.available.remove_child(self)
	Quest_Manager.availableQuests.erase(questID)
	Quest_Manager.started.add_child(self)
	Quest_Manager.startedQuests.append(questID)
	print("DEBUG >> Quest: [" + self.name + "] has been moved from Available to Started.")
	
	if startEvent != null:
		startEvent._on_execute()

func _get_objectives() -> Array:
	return objectives.get_children()

func _on_objective_completed(objective) -> void:
	var parent = objective.get_parent()
	parent.remove_child(objective)

func _connect_to_npc(npc) -> void:
	print("DEBUG >> Connecting NPC: [" + npc.name + "] to quest: [" + self.name + "].")	
	if Quest_Manager.completed.find_child(self.name) == null:
		self.npcName = npc.name
		npc.remove_child(self)
		Quest_Manager.available.add_child(self)
		Quest_Manager.availableQuests.append(questID)

func _complete_dialogue() -> void:
	if endEvent != null:
		endEvent._on_execute()
	if connectedNpc is Quest_NPC:
		connectedNpc.finishedDialogue = true
	Quest_Manager.started.remove_child(self)
	Dialogue_Manager._dialogue_completed(questDialogue)
	_is_quest_completely_finished()

func _run_quest_dialogue() -> void:
	Constants.UI._write_to_screen(questDialogue._read_dialogue(), npcName)

func _event_completion() -> void:
	_is_quest_completely_finished()

func _is_quest_completely_finished() -> void:
	if self.get_children().size() == 1:
		Quest_Manager.completed.add_child(self)
