extends Node2D

@export var spawn_interval = 0.5
@export var max_mobs = 7

@onready var player = get_tree().get_first_node_in_group("player")
@onready var score_label = $UI/ScoreLabel
var animation_scene = preload("res://scenes/cut_scene.tscn")
var quit_delay = 2.0
signal wave_completed

var mobs_spawned = 0
var mobs_killed = 0
var spawn_timer: Timer
var wave_completed_flag = false

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.connect("timeout", Callable(self, "_spawn_mob"))
	add_child(spawn_timer)
	connect("wave_completed", Callable(self, "_on_wave_completed"))

	_start_wave()

func _process(delta):
	if Input.is_action_pressed("QuitJeu"):
		get_tree().create_timer(quit_delay).connect("timeout", Callable(self, "_on_quit_timeout"))

	score_label.text = "Score: %d" % GameStats.score

	if mobs_spawned == 0 and get_tree().get_nodes_in_group("mobs").size() == 0 and mobs_killed >= 7 and not wave_completed_flag:
		emit_signal("wave_completed")
		wave_completed_flag = true

func _spawn_mob():
	if mobs_spawned < max_mobs:
		var mob = preload("res://scenes/mob_skeleton.tscn").instantiate()
		var angle = randf() * 2 * PI
		var distance = randf() * 200 + 100
		mob.position = player.position + Vector2(cos(angle), sin(angle)) * distance
		add_child(mob)
		mob.connect("died", Callable(self, "_on_mob_died"))
		mobs_spawned += 1
		if mobs_spawned == max_mobs:
			spawn_timer.stop()

func _start_wave():
	mobs_spawned = 0
	mobs_killed = 0
	wave_completed_flag = false
	spawn_timer.start()

func _on_mob_died(points):
	GameStats.score += points
	score_label.text = "Score: %d" % GameStats.score
	mobs_spawned -= 1
	mobs_killed += 1
	print("Mobs killed: %d" % mobs_killed)
	if mobs_spawned == 0 and mobs_killed >= 7 and not wave_completed_flag:
		emit_signal("wave_completed")
		wave_completed_flag = true

func _on_wave_completed():
	_play_animation_scene()

func _play_animation_scene():
	var animation_instance = animation_scene.instantiate()
	get_tree().root.add_child(animation_instance)
	queue_free()  # Free the wave1 scene after adding the cut scene

func _on_quit_timeout():
	JavaScriptBridge.eval("window.location.href='http://localhost:3000'")
