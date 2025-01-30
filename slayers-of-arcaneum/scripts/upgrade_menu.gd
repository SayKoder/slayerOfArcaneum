extends Control

@onready var Acceleration = $MarginContainer/HBoxContainer/AccelerationBtn as Button
@onready var IncreaseDamage = $MarginContainer/HBoxContainer/DamageBtn as Button
@onready var DashAbility = $MarginContainer/HBoxContainer/DashBtn as Button
@export var next_scene = "res://scenes/wave2.tscn"
@onready var anim_background = $UpBackground_Anilm

func _ready():
	if anim_background.has_animation("UpBackground_Anilm"):
		anim_background.play("UpBackground_Anilm")
	if Acceleration:
		Acceleration.connect("pressed", Callable(self, "_on_Acceleration_pressed"))
		Acceleration.grab_focus()
	if IncreaseDamage:
		IncreaseDamage.connect("pressed", Callable(self, "_on_IncreaseDamage_pressed"))
	if DashAbility:
		DashAbility.connect("pressed", Callable(self, "_on_DashAbility_pressed"))

func _process(delta):
	if Input.is_action_just_pressed("move_down"):
		_focus_next_button()
	elif Input.is_action_just_pressed("move_up"):
		_focus_previous_button()
	elif Input.is_action_just_pressed("menu_button"):
		_activate_button()

func _on_Acceleration_pressed():
	PlayerStats.speed += 50
	print("Upgraded speed")
	_close_menu()

func _on_IncreaseDamage_pressed():
	PlayerStats.projectile_damage += 5
	print("Upgraded projectile damage")
	_close_menu()

func _on_DashAbility_pressed():
	PlayerStats.can_dash = true
	print("Unlocked dash ability")
	_close_menu()

func _close_menu():
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file(next_scene)

func _activate_button():
	if Acceleration.has_focus():
		_on_Acceleration_pressed()
	elif IncreaseDamage.has_focus():
		_on_IncreaseDamage_pressed()
	elif DashAbility.has_focus():
		_on_DashAbility_pressed()

func _focus_next_button():
	if Acceleration.has_focus():
		IncreaseDamage.grab_focus()
	elif IncreaseDamage.has_focus():
		DashAbility.grab_focus()
	elif DashAbility.has_focus():
		Acceleration.grab_focus()

func _focus_previous_button():
	if Acceleration.has_focus():
		DashAbility.grab_focus()
	elif IncreaseDamage.has_focus():
		Acceleration.grab_focus()
	elif DashAbility.has_focus():
		IncreaseDamage.grab_focus()
