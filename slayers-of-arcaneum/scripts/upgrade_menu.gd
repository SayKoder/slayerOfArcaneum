class_name CustomUpgradeMenu
extends Control

@onready var Acceleration = $VBoxContainer/Acceleration as Button
@onready var IncreaseDamage = $VBoxContainer/IncreaseDamage as Button

func _ready():
	if Acceleration:
		print("Acceleration button found")
		Acceleration.connect("pressed", Callable(self, "_on_Acceleration_pressed"))
		Acceleration.grab_focus()
	else:
		print("Acceleration button not found")

	if IncreaseDamage:
		print("IncreaseDamage button found")
		IncreaseDamage.connect("pressed", Callable(self, "_on_IncreaseDamage_pressed"))
	else:
		print("IncreaseDamage button not found")

	print("Upgrade menu ready")

func _process(_delta):
	if Input.is_action_just_pressed("move_down"):
		_focus_next_button()
	elif Input.is_action_just_pressed("move_up"):
		_focus_previous_button()
	elif Input.is_action_just_pressed("menu_button"):
		_activate_button()

func _activate_button() -> void:
	if Acceleration.has_focus():
		_on_Acceleration_pressed()
	elif IncreaseDamage.has_focus():
		_on_IncreaseDamage_pressed()

func _focus_next_button() -> void:
	if Acceleration.has_focus():
		IncreaseDamage.grab_focus()
	elif IncreaseDamage.has_focus():
		Acceleration.grab_focus()

func _focus_previous_button() -> void:
	if Acceleration.has_focus():
		IncreaseDamage.grab_focus()
	elif IncreaseDamage.has_focus():
		Acceleration.grab_focus()

func _on_Acceleration_pressed() -> void:
	print("Acceleration button pressed")
	_on_upgrade_button_pressed(1)

func _on_IncreaseDamage_pressed() -> void:
	print("IncreaseDamage button pressed")
	_on_upgrade_button_pressed(2)

func _on_upgrade_button_pressed(upgrade_type):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("Player not found")
		return

	match upgrade_type:
		1:
			print("Upgrading speed")
			player.upgrade_speed()
		2:
			print("Upgrading damage")
			player.upgrade_projectile_damage()

	start_wave_two()
	get_tree().paused = false
	queue_free()

func start_wave_two():
	var main = get_tree().root.get_node("Main")
	if main:
		main.start_wave_two()
