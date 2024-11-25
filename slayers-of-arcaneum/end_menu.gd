class_name EndMenu
extends Control

@onready var Restart = $PanelContainer/VBoxContainer/Restart as Button
@onready var Quit = $PanelContainer/VBoxContainer/Quit as Button
@onready var level = preload("res://scenes/main_world.tscn")
func _ready():
	# Connecte les signaux des boutons
	Restart.pressed.connect(on_restart_pressed)
	Quit.pressed.connect(on_quit_pressed)

	# Définit le focus initial sur le bouton Restart
	Restart.grab_focus()

# Assurez-vous que les boutons acceptent le focus

func _process(delta):
	# Permet de gérer les entrées de la manette ou du clavier
	if Input.is_action_just_pressed("move_down"):
		_focus_next_button()
	elif Input.is_action_just_pressed("move_up"):
		_focus_previous_button()
	elif Input.is_action_just_pressed("menu_button"):
		_activate_button()

# Fonction pour activer le bouton actuellement sélectionné
func _activate_button() -> void:
	if Restart.has_focus():
		on_restart_pressed()
	elif Quit.has_focus():
		on_quit_pressed()

# Fonction pour passer au bouton suivant
func _focus_next_button() -> void:
	if Restart.has_focus():
		Quit.grab_focus()
	elif Quit.has_focus():
		Restart.grab_focus()

# Fonction pour passer au bouton précédent
func _focus_previous_button() -> void:
	if Restart.has_focus():
		Quit.grab_focus()
	elif Quit.has_focus():
		Restart.grab_focus()

# Fonction appelée lorsque le bouton Restart est pressé
func on_restart_pressed() -> void:
	get_tree().reload_current_scene()

# Fonction appelée lorsque le bouton Quit est pressé
func on_quit_pressed() -> void:
	JavaScriptBridge.eval("window.location.href='http://localhost:3000'")
