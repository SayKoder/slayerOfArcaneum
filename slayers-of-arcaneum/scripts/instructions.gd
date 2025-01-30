extends Control

@onready var first_lvl = "res://scenes/wave1.tscn"
@onready var sprite = $AnimationPlayer2/B0Spawn  
@onready var animation_player = $AnimationPlayer2
var start_delay = 2.0
var can_start_game = false

func _ready():
	sprite.visible = false 
	get_tree().create_timer(start_delay).connect("timeout", Callable(self, "_enable_start_game"))

func _process(delta):
	if can_start_game and Input.is_action_just_pressed("menu_button"):
		_start_game()

func _enable_start_game():
	can_start_game = true
	sprite.visible = true  
	animation_player.play("your_animation_name")  

func _start_game():
	get_tree().change_scene_to_file(first_lvl)
