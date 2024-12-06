extends CharacterBody2D

@export var speed = 150
@export var fire_rate = 0.7
@export var projectile_damage = 10
@export var projectile_speed = 300
@onready var projectile_scene = preload("res://scenes/projectile.tscn")
@onready var shooting_point = $ShootingPoint
@onready var hurt_box = $HurtBox
@onready var fire_timer = Timer.new()
signal health_depleted
var hp = 150.0
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
var is_attacking = false
var quit_delay = 2.0
var inactivity_delay = 60.0
var inactivity_timer = 0.0
var fire_two_projectiles = false

func _ready():
	add_to_group("player")
	if hurt_box:
		hurt_box.connect("hurt", Callable(self, "_on_HurtBox_hurt"))
	connect("health_depleted", Callable(self, "_on_health_depleted"))
	fire_timer.wait_time = fire_rate
	fire_timer.one_shot = true
	add_child(fire_timer)

func _process(delta):
	var move_velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		move_velocity.x += 1
	elif Input.is_action_pressed("move_left"):
		move_velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		move_velocity.y += 1
	elif Input.is_action_pressed("move_up"):
		move_velocity.y -= 1
	if move_velocity.length() > 0:
		move_velocity = move_velocity.normalized() * speed
	position += move_velocity * delta
	if move_velocity != Vector2.ZERO:
		inactivity_timer = 0.0
	else:
		inactivity_timer += delta
	if inactivity_timer >= inactivity_delay:
		get_tree().create_timer(quit_delay).connect("timeout", Callable(self, "_on_quit_timeout"))
	const DAMAGE_RATE = 30.0
	var overlapping_mobs = hurt_box.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		hp -= DAMAGE_RATE * overlapping_mobs.size() * delta
		$ProgressBar.value = hp
		if hp <= 0:
			health_depleted.emit()
			set_process(false)
			animation_player.stop()
			show_end_menu()
	if move_velocity.x > 0:
		sprite.flip_h = true
		animation_player.play("run_left")
	elif move_velocity.x < 0:
		sprite.flip_h = false
		animation_player.play("run_left")
	elif move_velocity.y > 0:
		animation_player.play("run_bottom")
	elif move_velocity.y < 0:
		animation_player.play("run_top")
	else:
		animation_player.play("idle")
	if Input.is_action_pressed("QuitJeu"):
		print("appuie sur Quit (Touche B8) effectue")
		get_tree().create_timer(quit_delay).connect("timeout", Callable(self, "_on_quit_timeout"))
	if Input.is_action_just_pressed("attack_1") and fire_timer.is_stopped():
		fire_projectile()
		if fire_two_projectiles:
			fire_projectile()
		fire_timer.start()

func fire_projectile():
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.global_position = shooting_point.global_position
	var closest_mob = get_closest_mob()
	if closest_mob != null:
		projectile_instance.target = closest_mob
		projectile_instance.damage = projectile_damage
		projectile_instance.speed = projectile_speed
	get_tree().root.add_child(projectile_instance)

func _on_health_depleted():
	print("Game Over")
	show_end_menu()
	set_process(false)
	animation_player.stop()

func get_closest_mob():
	var closest_mob = null
	var closest_distance = 1e10
	var mobs = get_tree().get_nodes_in_group("mobs")
	for mob in mobs:
		var distance = global_position.distance_to(mob.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_mob = mob
	return closest_mob

func _on_HurtBox_hurt(damage, angle, knockback):
	take_damage(damage)
	$ProgressBar.value = hp
	if hp <= 0:
		health_depleted.emit()
		set_process(false)
		animation_player.stop()
		show_end_menu()

func take_damage(amount: int) -> void:
	hp -= amount
	print("Damage taken: %d | Remaining HP: %d" % [amount, hp])
	if hp <= 0:
		die()

func die() -> void:
	print("The mob has died")
	queue_free()

func show_end_menu():
	var end_menu_scene = preload("res://scripts/end_menu.tscn")
	var end_menu_instance = end_menu_scene.instantiate()
	end_menu_instance.global_position = global_position
	get_tree().root.add_child(end_menu_instance)
	end_menu_instance.grab_focus()

func upgrade_fire_two_projectiles():
	fire_two_projectiles = true
	print("Upgraded to fire two projectiles")

func upgrade_projectile_damage():
	projectile_damage += 5
	print("Upgraded projectile damage")

func upgrade_speed():
	speed += 50
	print("Upgraded speed")

func _on_quit_timeout():
	JavaScriptBridge.eval("window.location.href='http://localhost:3000'")
