extends Control

@onready var Acceleration2 = $HBoxContainer/AccelerationBtn2 as Button
@onready var IncreaseDamage2 = $HBoxContainer/IncreaseDamageBtn2 as Button
@onready var RegeneHealtPlayer2 = $HBoxContainer/RegeneHealtPlayerBtn2 as Button
@export var next_scene = "res://scenes/wave3.tscn"

var player

func _ready():
	if Acceleration2:
		Acceleration2.connect("pressed", Callable(self, "_on_Acceleration_pressed"))
		Acceleration2.grab_focus()
	if IncreaseDamage2:
		IncreaseDamage2.connect("pressed", Callable(self, "_on_IncreaseDamage_pressed"))
	if RegeneHealtPlayer2:
		RegeneHealtPlayer2.connect("pressed", Callable(self, "_on_RegeneHealtPlayer_pressed"))

func _on_Acceleration_pressed():
	PlayerStats.speed += 50
	print("Upgraded speed")
	_close_menu()

func _on_IncreaseDamage_pressed():
	PlayerStats.projectile_damage += 5
	print("Upgraded projectile damage")
	_close_menu()

func _on_RegeneHealtPlayer_pressed():
	PlayerStats.hp = min(PlayerStats.hp + 50, PlayerStats.max_hp)
	print("Regenerated health")
	_close_menu()

func _close_menu():
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file(next_scene)
