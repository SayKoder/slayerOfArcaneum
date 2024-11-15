extends Node2D

@export var mob_scene = preload("res://scenes/mob_skeleton.tscn")
@export var spawn_radius = 500  # Radius around the player where mobs can spawn
@export var spawn_interval = 0.5  # Time interval between spawns in seconds
@export var max_mobs = 50  # Maximum number of mobs to spawn in a wave

@onready var player = get_tree().get_first_node_in_group("player")
@onready var score_label = $Player/ScoreLabel  # Assurez-vous d'avoir un Label nommé "ScoreLabel" comme enfant du joueur
var mobs_spawned = 0  # Counter for the number of mobs spawned
var spawn_timer: Timer
var score = 0  # Variable pour le score

func _ready():
	# Start the mob spawning timer
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.connect("timeout", Callable(self, "_spawn_mob"))
	add_child(spawn_timer)
	spawn_timer.start()

func _process(delta):
	# Update the score label position relative to the player
	score_label.global_position = player.global_position + Vector2(0, -50)

func _spawn_mob():
	if mobs_spawned < max_mobs:
		var mob_instance = mob_scene.instantiate()
		var angle = randf_range(0, 2 * PI)
		var random_position = player.global_position + Vector2(cos(angle), sin(angle)) * spawn_radius
		mob_instance.global_position = random_position
		mob_instance.connect("died", Callable(self, "_on_mob_died"))
		add_child(mob_instance)
		mobs_spawned += 1
	else:
		# Stop the timer if the maximum number of mobs has been spawned
		spawn_timer.stop()

func _on_mob_died():
	score += 5
	score_label.text = "Score: %d" % score
