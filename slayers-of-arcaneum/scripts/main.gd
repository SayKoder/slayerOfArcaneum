# extends Node2D

# @export var wave_scenes = [preload("res://scenes/wave1.tscn"), preload("res://scenes/wave2.tscn"), preload("res://scenes/wave3.tscn")]
# @export var spawn_interval = 0.5
# @export var max_mobs = 7

# @onready var player = get_tree().get_first_node_in_group("player")
# @onready var score_label = $UI/ScoreLabel
# @onready var upgrade_menu_scene = preload("res://scenes/upgrade_menu.tscn")
# @onready var upgrade_menu_scene2 = preload("res://scenes/upgrade_menu2.tscn")
# @onready var player_stats_ui = preload("res://scenes/player_stats_ui.tscn")
# var quit_delay = 2.0
# signal wave_completed

# var mobs_spawned = 0
# var score = 0
# var current_wave = 1
# var spawn_timer: Timer

# func _ready():
#  spawn_timer = Timer.new()
#  spawn_timer.wait_time = spawn_interval
#  spawn_timer.connect("timeout", Callable(self, "_spawn_mob"))
#  add_child(spawn_timer)
#  connect("wave_completed", Callable(self, "_on_wave_completed"))

#  if not $UI.has_node("PlayerStatsUI"):
#   var ui_instance = player_stats_ui.instantiate()
#   $UI.add_child(ui_instance)

# func _process(delta):
#  if Input.is_action_pressed("QuitJeu"):
#   get_tree().create_timer(quit_delay).connect("timeout", Callable(self, "_on_quit_timeout"))
#  if score_label:
#   score_label.text = "Score: %d" % score

# func _spawn_mob():
#  if mobs_spawned < max_mobs:
#   var wave_scene = wave_scenes[current_wave - 1]
#   var wave_instance = wave_scene.instantiate()
#   add_child(wave_instance)
#   mobs_spawned += 1
#   if mobs_spawned == max_mobs:
#    spawn_timer.stop()

# func _start_new_wave():
#  mobs_spawned = 0
#  spawn_timer.start()

# func _on_mob_died(points):
#  score += points
#  score_label.text = "Score: %d" % score
#  mobs_spawned -= 1
#  if mobs_spawned == 0:
#   emit_signal("wave_completed")

# func _on_wave_completed():
#  current_wave += 1
#  _show_upgrade_menu()

# func _show_upgrade_menu():
#  var upgrade_menu_instance
#  if current_wave == 2:
#   upgrade_menu_instance = upgrade_menu_scene.instantiate()
#  elif current_wave == 3:
#   upgrade_menu_instance = upgrade_menu_scene2.instantiate()
#  $UI.add_child(upgrade_menu_instance)
#  get_tree().paused = true

# func upgrade_speed():
#  player.speed += 50
#  print("Upgraded speed")
#  get_tree().paused = false

# func upgrade_projectile_damage():
#  player.projectile_damage += 5
#  print("Upgraded projectile damage")
#  get_tree().paused = false

# func regenerate_health():
#  player.hp = min(player.hp + 50, player.max_hp)
#  print("Regenerated health")
#  get_tree().paused = false

# func start_wave_two():
#  current_wave = 2
#  _start_new_wave()
#  get_tree().paused = false

# func _on_quit_timeout():
#  JavaScriptBridge.eval("window.location.href='http://localhost:3000'")
