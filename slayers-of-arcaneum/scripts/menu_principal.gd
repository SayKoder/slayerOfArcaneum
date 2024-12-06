extends Control

@onready var first_lvl = "res://scenes/main_world.tscn"
@onready var start_button = $StartBtn as Button
@onready var quit_button = $QuitBtn as Button

func _ready():
	start_button.connect("pressed", Callable(self, "_on_start_button_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_quit_button_pressed"))

	# Set initial focus on the start button
	start_button.grab_focus()

func _process(_delta):
	# Handle input for navigating and activating buttons
	if Input.is_action_just_pressed("move_down"):
		_focus_next_button()
	elif Input.is_action_just_pressed("move_up"):
		_focus_previous_button()
	elif Input.is_action_just_pressed("StartGame"):
		_activate_button()

func _activate_button() -> void:
	if start_button.has_focus():
		_on_start_button_pressed()
	elif quit_button.has_focus():
		_on_quit_button_pressed()

func _focus_next_button() -> void:
	if start_button.has_focus():
		quit_button.grab_focus()
	elif quit_button.has_focus():
		start_button.grab_focus()

func _focus_previous_button() -> void:
	if start_button.has_focus():
		quit_button.grab_focus()
	elif quit_button.has_focus():
		start_button.grab_focus()

func _on_start_button_pressed():
	get_tree().change_scene_to_file(first_lvl)

func _on_quit_button_pressed():
	JavaScriptBridge.eval("window.location.href='http://localhost:3000'")
