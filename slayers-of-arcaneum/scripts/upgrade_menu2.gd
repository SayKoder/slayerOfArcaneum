extends Control

@onready var Acceleration = $HBoxContainer/AccelerationBtn as Button
@onready var IncreaseDamage = $HBoxContainer/IncreaseDamageBtn as Button
@onready var RegeneHealtPlayer = $HBoxContainer/RegeneHealtPlayerBtn as Button
@export var next_scene = "res://scenes/wave3.tscn"  # Path to the next scene

@onready var player_stats = get_tree().get_first_node_in_group("player")

func _ready():
	if Acceleration:
		Acceleration.connect("pressed", Callable(self, "_on_Acceleration_pressed"))
		Acceleration.grab_focus()
	if IncreaseDamage:
		IncreaseDamage.connect("pressed", Callable(self, "_on_IncreaseDamage_pressed"))
	if RegeneHealtPlayer:
		RegeneHealtPlayer.connect("pressed", Callable(self, "_on_RegeneHealtPlayer_pressed"))

func _on_Acceleration_pressed():
	player_stats.speed += 50
	print("Upgraded speed")
	_close_menu()

func _on_IncreaseDamage_pressed():
	player_stats.projectile_damage += 5
	print("Upgraded projectile damage")
	_close_menu()

func _on_RegeneHealtPlayer_pressed():
	player_stats.hp = min(player_stats.hp + 50, player_stats.max_hp)
	print("Regenerated health")
	_close_menu()

func _close_menu():
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file(next_scene)