extends Control

@onready var Acceleration = $HBoxContainer/AccelerationBtn as Button
@onready var IncreaseDamage = $HBoxContainer/DamageBtn as Button
@onready var RegeneHealtPlayer = $HBoxContainer/RegenerationBtn as Button
@export var next_scene2 = "res://scenes/wave3.tscn"

func _ready():
	Acceleration.connect("pressed", Callable(self, "_on_acceleration_btn_pressed"))
	IncreaseDamage.connect("pressed", Callable(self, "_on_damage_btn_pressed"))
	RegeneHealtPlayer.connect("pressed", Callable(self, "_on_regeneration_btn_pressed"))
	Acceleration.grab_focus()

func _process(_delta):
	if Input.is_action_just_pressed("move_down"):
		_focus_next_button()
	elif Input.is_action_just_pressed("move_up"):
		_focus_previous_button()
	elif Input.is_action_just_pressed("menu_button"):
		_activate_button()

func _on_acceleration_btn_pressed():
	PlayerStats.speed += 50
	_close_menu2()

func _on_damage_btn_pressed():
	PlayerStats.projectile_damage += 5
	_close_menu2()

func _on_regeneration_btn_pressed():
	PlayerStats.hp = min(PlayerStats.hp + 50, PlayerStats.max_hp)
	_close_menu2()

func _close_menu2():
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file(next_scene2)

func _activate_button():
	if Acceleration.has_focus():
		_on_acceleration_btn_pressed()
	elif IncreaseDamage.has_focus():
		_on_damage_btn_pressed()
	elif RegeneHealtPlayer.has_focus():
		_on_regeneration_btn_pressed()

func _focus_next_button():
	if Acceleration.has_focus():
		IncreaseDamage.grab_focus()
	elif IncreaseDamage.has_focus():
		RegeneHealtPlayer.grab_focus()
	elif RegeneHealtPlayer.has_focus():
		Acceleration.grab_focus()

func _focus_previous_button():
	if Acceleration.has_focus():
		RegeneHealtPlayer.grab_focus()
	elif IncreaseDamage.has_focus():
		Acceleration.grab_focus()
	elif RegeneHealtPlayer.has_focus():
		IncreaseDamage.grab_focus()
