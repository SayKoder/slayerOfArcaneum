extends Control

@onready var Acceleration2 = $HBoxContainer/AccelerationBtn2 as Button
@onready var IncreaseDamage2 = $HBoxContainer/IncreaseDamageBtn2 as Button
@onready var RegeneHealtPlayer2 = $HBoxContainer/RegeneHealtPlayerBtn2 as Button
@export var next_scene = "res://scenes/wave3.tscn"  # Path to the next scene

var player

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("Player not found")
		return

	if Acceleration2:
		Acceleration2.connect("pressed", Callable(self, "_on_Acceleration_pressed"))
		Acceleration2.grab_focus()
	if IncreaseDamage2:
		IncreaseDamage2.connect("pressed", Callable(self, "_on_IncreaseDamage_pressed"))
	if RegeneHealtPlayer2:
		RegeneHealtPlayer2.connect("pressed", Callable(self, "_on_RegeneHealtPlayer_pressed"))

func _on_Acceleration_pressed():
	player.speed += 50
	print("Upgraded speed")
	_close_menu()

func _on_IncreaseDamage_pressed():
	player.projectile_damage += 5
	print("Upgraded projectile damage")
	_close_menu()

func _on_RegeneHealtPlayer_pressed():
	player.hp = min(player.hp + 50, player.max_hp)
	print("Regenerated health")
	_close_menu()

func _close_menu():
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file(next_scene)
