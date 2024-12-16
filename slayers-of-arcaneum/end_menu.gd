class_name EndMenu
extends Control

@onready var Restart = $PanelContainer/VBoxContainer/Restart as Button
@onready var Quit = $PanelContainer/VBoxContainer/Quit as Button
@onready var level = ("res://scenes/wave1.tscn")

func _ready():
	# Connect button signals
	Restart.pressed.connect(on_restart_pressed)
	Quit.pressed.connect(on_quit_pressed)

	# Set initial focus on the Restart button
	Restart.grab_focus()

func _process(delta):
	# Handle input for navigating buttons
	if Input.is_action_just_pressed("move_down"):
		_focus_next_button()
	elif Input.is_action_just_pressed("move_up"):
		_focus_previous_button()
	elif Input.is_action_just_pressed("menu_button"):
		_activate_button()

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
	GameStats.reset()
	PlayerStats.reset()
	queue_free()  # Remove the end menu instance from the scene tree
	get_tree().change_scene_to_file(level)

func on_quit_pressed() -> void:
	JavaScriptBridge.eval("window.location.href='http://localhost:3000'")
