extends Control

signal upgrade_completed

@onready var Acceleration2 = $HBoxContainer/AccelerationBtn as Button
@onready var IncreaseDamage2 = $HBoxContainer/IncreaseDamageBtn as Button
@onready var RegeneHealtPlayer2 = $HBoxContainer/RegeneHealtPlayerBtn as Button
@export var next_scene2 = "res://scenes/wave3.tscn"

func _ready():
	if Acceleration2:
		Acceleration2.connect("pressed", Callable(self, "_on_Acceleration2_pressed"))
		Acceleration2.grab_focus()
	if IncreaseDamage2:
		IncreaseDamage2.connect("pressed", Callable(self, "_on_IncreaseDamage2_pressed"))
	if RegeneHealtPlayer2:
		RegeneHealtPlayer2.connect("pressed", Callable(self, "_on_RegeneHealtPlayer2_pressed"))

func _on_Acceleration2_pressed():
	print("Acceleration upgrade selected")
	_close_menu()

func _on_IncreaseDamage2_pressed():
	print("Increase damage upgrade selected")
	_close_menu()

func _on_RegeneHealtPlayer2_pressed():
	print("Regenerate health upgrade selected")
	_close_menu()

func _close_menu():
	print("Closing menu and changing scene to ", next_scene2)
	emit_signal("upgrade_completed")
	get_tree().paused = false
	get_tree().change_scene_to_file(next_scene2)
	queue_free()
