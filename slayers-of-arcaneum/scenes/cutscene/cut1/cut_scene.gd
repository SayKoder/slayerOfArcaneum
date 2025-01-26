extends Node2D

@export var animation_player: AnimationPlayer
@export var next_scene: PackedScene = preload("res://scenes/menu_save.tscn")
@export var autoplay: bool = false


func _ready():
	# Connecte le signal "animation_finished" à une fonction
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
	if autoplay:
		animation_player.play()

func _on_animation_finished(animation_name: String):
	print("Animation terminée :", animation_name)
	# Change de scène après la fin de l'animation
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)
	else:
		print("Aucune scène suivante spécifiée.")
