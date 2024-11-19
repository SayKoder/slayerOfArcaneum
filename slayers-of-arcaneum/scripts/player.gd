extends CharacterBody2D

@export var speed = 150
@export var fire_rate = 0.5  # Minimum delay between each projectile in seconds
@export var projectile_damage = 10  # Damage of each projectile
@export var projectile_speed = 300  # Speed of each projectile
@onready var projectile_scene = preload("res://scenes/projectile.tscn")
@onready var shooting_point = $ShootingPoint
@onready var hurt_box = $HurtBox
@onready var fire_timer = Timer.new()
signal health_depleted
var hp = 150.0  # Initialisation des points de vie.
@onready var sprite = $Sprite2D  # Sprite2D à inverser horizontalement.
@onready var animation_player = $AnimationPlayer
var is_attacking = false
var quit_delay = 2.0  # Délai avant de quitter le jeu en secondes
var inactivity_delay = 10.0  # Délai d'inactivité en secondes
var inactivity_timer = 0.0  # Compteur d'inactivité

func _ready():
	hurt_box.connect("hurt", Callable(self, "_on_HurtBox_hurt"))
	connect("health_depleted", Callable(self, "_on_health_depleted"))
	fire_timer.wait_time = fire_rate
	fire_timer.one_shot = true
	add_child(fire_timer)

func _process(delta):
	var move_velocity = Vector2.ZERO # Le vecteur de mouvement du joueur.

	# Autoriser les mouvements même si le personnage attaque
	if Input.is_action_pressed("move_right"):
		move_velocity.x += 1
	elif Input.is_action_pressed("move_left"):
		move_velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		move_velocity.y += 1
	elif Input.is_action_pressed("move_up"):
		move_velocity.y -= 1

	# Normaliser la vitesse si le personnage se déplace
	if move_velocity.length() > 0:
		move_velocity = move_velocity.normalized() * speed

	# Déplacer le joueur
	position += move_velocity * delta

	# Réinitialiser le compteur d'inactivité si une touche est pressée
	if move_velocity != Vector2.ZERO:
		inactivity_timer = 0.0
	else:
		inactivity_timer += delta

	# Vérifier si le joueur est inactif
	if inactivity_timer >= inactivity_delay:
		await get_tree().create_timer(quit_delay).timeout
		JavaScriptBridge.eval("window.location.href='http://localhost:3000'")

	const DAMAGE_RATE = 2.0
	var overlapping_mobs = hurt_box.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		hp -= DAMAGE_RATE * overlapping_mobs.size() * delta
		$ProgressBar.value = hp
		if hp <= 0:
			health_depleted.emit()
			# Désactive les contrôles du joueur
			set_process(false)
			# Arrête toutes les animations
			animation_player.stop()
			# Optionnel: Afficher un écran de Game Over ou réinitialiser le jeu
			show_end_menu()

	# Ajout du code demandé
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

	# Gestion du délai avant de quitter le jeu
	if Input.is_action_pressed("QuitJeu"):
		print("appuie sur Quit (Touche B8) effectue")
		await get_tree().create_timer(quit_delay).timeout
		JavaScriptBridge.eval("window.location.href='http://localhost:3000'")

	# Lancer un projectile avec un délai minimum entre chaque tir
	if Input.is_action_just_pressed("attack_1") and fire_timer.is_stopped():
		var projectile_instance = projectile_scene.instantiate()
		projectile_instance.global_position = shooting_point.global_position
		var closest_mob = get_closest_mob()
		if closest_mob != null:
			projectile_instance.target = closest_mob
			projectile_instance.damage = projectile_damage  # Set projectile damage
			projectile_instance.speed = projectile_speed  # Set projectile speed
		get_tree().root.add_child(projectile_instance)
		fire_timer.start()

# Fonction appelée lorsque la santé est épuisée
func _on_health_depleted():
	print("Game Over")
	# Rendre le menu de fin visible
	show_end_menu()
	# Désactiver les contrôles du joueur
	set_process(false)
	# Arrêter toutes les animations
	animation_player.stop()

# Fonction pour obtenir le mob le plus proche
func get_closest_mob():
	var closest_mob = null
	var closest_distance = 1e10  # Initialize to a large float value
	var mobs = get_tree().get_nodes_in_group("mobs")  # Assurez-vous que vos mobs sont dans un groupe nommé "mobs"

	for mob in mobs:
		var distance = global_position.distance_to(mob.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_mob = mob

	return closest_mob

func _on_HurtBox_hurt(damage, angle, knockback):
	hp -= damage
	$ProgressBar.value = hp
	if hp <= 0:
		health_depleted.emit()
		set_process(false)
		animation_player.stop()
		show_end_menu()

func show_end_menu():
	var end_menu_scene = preload("res://scripts/end_menu.tscn")  # Update the path to the correct location
	var end_menu_instance = end_menu_scene.instantiate()
	end_menu_instance.global_position = global_position  # Set the position to the player's position
	get_tree().root.add_child(end_menu_instance)
	end_menu_instance.grab_focus()