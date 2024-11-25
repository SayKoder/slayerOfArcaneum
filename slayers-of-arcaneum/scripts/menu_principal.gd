extends Control

@onready var first_lvl = preload("res://scenes/main_world.tscn")

func _ready():
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("StartGame"):  # Assuming "StartGame" is mapped to the B8 key
		get_tree().change_scene_to_packed(first_lvl)

	if event.is_action_pressed("QuitJeu"):  # Assuming "QuitJeu" is mapped to the quit key
		print("appuie sur Quit (Touche B8) effectue")
		JavaScriptBridge.eval("window.location.href='http://localhost:3000'")
