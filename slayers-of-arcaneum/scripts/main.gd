extends Node2D

@export var mob_scenes = [preload("res://scenes/mob_skeleton.tscn"), preload("res://scenes/shadow.tscn"), preload("res://scenes/ghost.tscn")]
@export var spawn_radius = 500
@export var spawn_interval = 0.5
@export var max_mobs = 10
@export var wave_interval = 30.0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var score_label = $Player/ScoreLabel
var mobs_spawned = 0
var spawn_timer: Timer
var wave_timer: Timer
var score = 0
var current_wave = 1

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.connect("timeout", Callable(self, "_spawn_mob"))
	add_child(spawn_timer)
	spawn_timer.start()

	wave_timer = Timer.new()
	wave_timer.wait_time = wave_interval
	wave_timer.connect("timeout", Callable(self, "_start_new_wave"))
	add_child(wave_timer)
	wave_timer.start()

func _process(delta):
	score_label.global_position = player.global_position + Vector2(0, -50)

func _spawn_mob():
	if mobs_spawned < max_mobs:
		var mob_scene
		if current_wave == 1:
			mob_scene = mob_scenes[0]  # Only spawn MobSkeleton in the first wave
		elif current_wave == 2:
			mob_scene = mob_scenes[randi() % 2]  # Spawn MobSkeleton or Shadow in the second wave
		else:
			mob_scene = mob_scenes[randi() % 3]  # Spawn any mob in the third wave and beyond

		var mob_instance = mob_scene.instantiate()
		var angle = randf_range(0, 2 * PI)
		var random_position = player.global_position + Vector2(cos(angle), sin(angle)) * spawn_radius
		mob_instance.global_position = random_position
		var points = 0
		if mob_instance is MobSkeleton:
			points = 5
		elif mob_instance is Shadow:
			points = 10
		elif mob_instance is Ghost:
			points = 15
		mob_instance.connect("died", Callable(self, "_on_mob_died").bind(points))
		add_child(mob_instance)
		mobs_spawned += 1
	else:
		spawn_timer.stop()

func _start_new_wave():
	mobs_spawned = 0
	current_wave += 1
	spawn_timer.start()

func _on_mob_died(points):
	score += points
	score_label.text = "Score: %d" % score
