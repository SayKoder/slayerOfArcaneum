extends Node2D

@export var spawn_interval = 0.4
@export var max_mobs = 10

@onready var player = get_tree().get_first_node_in_group("player")
@onready var score_label = $UI/ScoreLabel
@onready var player_stats_ui = preload("res://scenes/player_stats_ui.tscn")
var quit_delay = 2.0
signal wave_completed

var mobs_spawned = 0
var mobs_killed = 0
var spawn_timer: Timer

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.connect("timeout", Callable(self, "_spawn_mob"))
	add_child(spawn_timer)
	connect("wave_completed", Callable(self, "_on_wave_completed"))

	if not $UI.has_node("PlayerStatsUI"):
		var ui_instance = player_stats_ui.instantiate()
		$UI.add_child(ui_instance)

	_start_wave()

func _process(delta):
	if Input.is_action_pressed("QuitJeu"):
		get_tree().create_timer(quit_delay).connect("timeout", Callable(self, "_on_quit_timeout"))
	if score_label:
		score_label.text = "Score: %d" % GameStats.score

func _spawn_mob():
	if mobs_spawned < max_mobs:
		var mob = preload("res://scenes/ghost.tscn").instantiate()
		mob.position = Vector2(randi() % 800, randi() % 600)  # Random position within 800x600 area
		add_child(mob)
		mob.connect("died", Callable(self, "_on_mob_died"))
		mobs_spawned += 1
		if mobs_spawned == max_mobs:
			spawn_timer.stop()

func _start_wave():
	mobs_spawned = 0
	mobs_killed = 0
	spawn_timer.start()

func _on_mob_died(points):
	GameStats.score += points
	score_label.text = "Score: %d" % GameStats.score
	mobs_spawned -= 1
	mobs_killed += 1
	if mobs_spawned == 0 and mobs_killed >= max_mobs:
		emit_signal("wave_completed")

func upgrade_speed():
	player.speed += 50
	get_tree().paused = false

func upgrade_projectile_damage():
	player.projectile_damage += 5
	get_tree().paused = false

func regenerate_health():
	player.hp = min(player.hp + 50, player.max_hp)
	get_tree().paused = false

func _on_quit_timeout():
	JavaScriptBridge.eval("window.location.href='http://localhost:3000'")
