extends Control

@onready var startButton = $"Start Button"
@onready var quitButton = $"Quit Button"
@onready var currentFocus : Button = startButton
@onready var musicSound = $Song
@onready var buttonSound = $"Button Sound"

var menuMusic : AudioStream = load("res://Assets/Audio/Songs/into_abyss.mp3")
var buttonHighlight = load("res://Assets/Audio/click (1).wav")
var buttonClick = load("res://Assets/Audio/click.wav")

func _ready() -> void:
	MusicManager._play_music(menuMusic)
	_focus_current()

func _focus_current() -> void:
	if currentFocus == null:
		currentFocus = startButton
	currentFocus.grab_focus()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if startButton.has_focus() == false && quitButton.has_focus() == false:
		if Input.is_action_just_pressed("ui_focus_next") || Input.is_action_just_pressed("ui_focus_prev"):
			_focus_current()

func _start_button_highlight() -> void:
	_highlight_button(startButton)

func _start_button_unhighlight() -> void:
	_unhighlight_button(startButton)

func _quit_button_highlight() -> void:
	_highlight_button(quitButton)
	
func _quit_button_unhighlight() -> void:
	_unhighlight_button(quitButton)

func _highlight_button(button) -> void:
	buttonSound.stream = buttonHighlight
	buttonSound.play()
	button.grab_focus()
	button.icon = load("res://Assets/MenuSelectedIcon.png")
	currentFocus = button
	button.add_theme_constant_override("h_separation", 10)

func _unhighlight_button(button) -> void:
	button.release_focus()
	button.icon = null

func _on_start_button_pressed() -> void:
	buttonSound.stream = buttonClick
	buttonSound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Scenes/Levels/Outside.tscn")

func _on_quit_button_pressed() -> void:
	buttonSound.stream = buttonClick
	buttonSound.play()
	get_tree().quit()

func _play_song() -> void:
	musicSound.play()
