extends Node2D

@export var animation_player: AnimationPlayer
@onready var upgrade_menu_scene = preload("res://scenes/upgrade_menu.tscn")
@export var autoplay: bool = false

var scene_changed = false

func _ready():
	if animation_player == null:
		animation_player = $AnimationPlayer
	if animation_player == null:
		print("Error: AnimationPlayer node not found")
		return

	var callable = Callable(self, "_on_animation_finished")
	if not animation_player.is_connected("animation_finished", callable):
		animation_player.connect("animation_finished", callable)
	if autoplay:
		animation_player.play()

func _on_animation_finished(animation_name: String):
	if scene_changed:
		return
	scene_changed = true
	print("Animation finished:", animation_name)
	_show_upgrade_menu()
	queue_free()

func _show_upgrade_menu():
	var upgrade_menu_instance = upgrade_menu_scene.instantiate()
	get_tree().root.add_child(upgrade_menu_instance)
