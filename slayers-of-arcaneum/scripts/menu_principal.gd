extends Control
@onready var first_lvl = preload("res://scenes/main_world.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function bo"res://scenes/main_world.tscn"dy.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_btn_button_down() -> void:
	if Input.is_action_pressed("StartGame"):
		get_tree().change_scene_to_packed(first_lvl)


func _on_quit_btn_button_down() -> void:
	if Input.is_action_pressed("QuitJeu"):
		print("appuie sur Quit (Touche B8) effectue")
		JavaScriptBridge.eval("window.location.href='http://localhost:3000'")
