extends Control

@onready var Acceleration = $HBoxContainer/AccelerationBtn as Button
@onready var IncreaseDamage = $HBoxContainer/IncreaseDamageBtn as Button
@onready var RegeneHealtPlayer = $HBoxContainer/RegeneHealtPlayerBtn as Button
@export var next_scene = "res://scenes/wave2.tscn"

func _ready():
	if Acceleration:
		Acceleration.connect("pressed", Callable(self, "_on_Acceleration_pressed"))
		Acceleration.grab_focus()
	if IncreaseDamage:
		IncreaseDamage.connect("pressed", Callable(self, "_on_IncreaseDamage_pressed"))
	if RegeneHealtPlayer:
		RegeneHealtPlayer.connect("pressed", Callable(self, "_on_RegeneHealtPlayer_pressed"))

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
