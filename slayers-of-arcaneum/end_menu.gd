extends Control

@onready var Restart = $PanelContainer/VBoxContainer/Restart as Button
@onready var Quit = $PanelContainer/VBoxContainer/Quit as Button
@onready var level = "res://scenes/wave1.tscn"
@onready var score_end = $score_end as Label  

var game_stats

func _ready():
	# Connect button signals
	Restart.pressed.connect(on_restart_pressed)
	Quit.pressed.connect(on_quit_pressed)

	# Set initial focus on the Restart button
	Restart.grab_focus()

	# Get the GameStats node
	game_stats = get_node("/root/GameStats")

	# Update the score display
	update_score_display()

func _process(delta):
	# Update the score display
	update_score_display()

	# Handle input for navigating buttons
	if Input.is_action_just_pressed("move_down"):
		_focus_next_button()
	elif Input.is_action_just_pressed("move_up"):
		_focus_previous_button()
	elif Input.is_action_just_pressed("menu_button"):
		_activate_button()

func update_score_display():
	if game_stats and score_end: 
		score_end.text = "Score: %d" % game_stats.get_score()

func _activate_button() -> void:
	if Restart.has_focus():
		on_restart_pressed()
	elif Quit.has_focus():
		on_quit_pressed()

func _focus_next_button() -> void:
	if Restart.has_focus():
		Quit.grab_focus()
	elif Quit.has_focus():
		Restart.grab_focus()

func _focus_previous_button() -> void:
	if Restart.has_focus():
		Quit.grab_focus()
	elif Quit.has_focus():
		Restart.grab_focus()

func on_restart_pressed() -> void:
	game_stats.reset()
	get_tree().change_scene_to_file(level)

func on_quit_pressed() -> void:
	game_stats.save_score()
	JavaScriptBridge.eval("window.location.href='http://localhost:3000'")
