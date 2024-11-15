extends CharacterBody2D

@export var speed = 150
@onready var projectile_scene = preload("res://scenes/projectile.tscn")
@onready var shooting_point = $ShootingPoint
@onready var hurt_box = $HurtBox
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

func _process(delta):
	var move_velocity = Vector2.ZERO # Le vecteur de mouvement du joueur.

	# Autoriser les mouvements même si le personnage attaque
	if Input.is_action_pressed("move_right"):
		move_velocity.x += 1
		sprite.flip_h = true
		animation_player.play("run_left")  # Utilise l'animation gauche et la retourne.
	elif Input.is_action_pressed("move_left"):
		move_velocity.x -= 1
		sprite.flip_h = false
		animation_player.play("run_left")
	elif Input.is_action_pressed("move_down"):
		move_velocity.y += 1
		animation_player.play("run_bottom")
	elif Input.is_action_pressed("move_up"):
		move_velocity.y -= 1
		animation_player.play("run_top")
	else:
		# Revenir à l’animation d’inactivité selon la direction.
		if sprite.flip_h:
			animation_player.play("idle_left")
		else:
			animation_player.play("idle")

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

	# Si on n'est pas en train d'attaquer, jouer les animations de déplacement
	if not is_attacking:
		if move_velocity.length() == 0:
			animation_player.play("idle")
		else:
			animation_player.play("running")

	# Ajout du code demandé
	if move_velocity.x > 0:
		animation_player.play("run_right")
	elif move_velocity.x < 0:
		animation_player.play("run_left")
	elif move_velocity.y > 0:
		animation_player.play("run_bottom")
	elif move_velocity.y < 0:
		animation_player.play("run_top")
	else:
		animation_player.play("idle")

	if move_velocity.length() > 0:
		move_velocity = move_velocity.normalized() * speed

	position += move_velocity * delta

	# Gestion du délai avant de quitter le jeu
	if Input.is_action_pressed("QuitJeu"):
		print("appuie sur Quit (Touche B8) effectue")
		await get_tree().create_timer(quit_delay).timeout
		JavaScriptBridge.eval("window.location.href='http://localhost:3000'")

	# Lancer un projectile
	if Input.is_action_just_pressed("fire"):
		var projectile_instance = projectile_scene.instantiate()
		projectile_instance.global_position = shooting_point.global_position
		var closest_mob = get_closest_mob()
		if closest_mob != null:
			projectile_instance.target = closest_mob
		get_tree().root.add_child(projectile_instance)

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
	var closest_distance = INF
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
