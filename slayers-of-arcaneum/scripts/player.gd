extends CharacterBody2D

@onready var sprite = $Sprite2D
@export var speed: float = 150.0
@onready var animations = $AnimationPlayer
@onready var projectile_scene = preload("res://scenes/projectile.tscn")
signal health_depleted
var hp = 50  # Initialisation des points de vie.

@onready var end_menu = $"../EndMenu"  # Assurez-vous que ce chemin correspond à votre menu de fin.
var is_attacking = false
var quit_delay = 2.0  # Délai avant de quitter le jeu en secondes
var inactivity_delay = 10.0  # Délai d'inactivité en secondes
var inactivity_timer = 0.0  # Compteur d'inactivité

# Called every frame. 'delta' is the elapsed time since the previous frame.
var last_direction = "_down" # Par défaut, le personnage regarde vers le bas

func handleInput(delta):
	var moveDirection = Input.get_vector("move_left", "move_right", "move_up","move_down")
	velocity = moveDirection * speed

	# Enregistrer la dernière direction si le personnage bouge
	if velocity.x < 0:
		last_direction = "_left"
	elif velocity.x > 0:
		last_direction = "_right"
	elif velocity.y < 0:
		last_direction = "_up"
	elif velocity.y > 0:
		last_direction = "_down"

	# Réinitialiser le compteur d'inactivité si une touche est pressée
	if velocity != Vector2.ZERO:
		inactivity_timer = 0.0
	else:
		inactivity_timer += delta

	# Vérifier si le joueur est inactif
	if inactivity_timer >= inactivity_delay:
		await get_tree().create_timer(quit_delay).timeout
		JavaScriptBridge.eval("window.location.href='http://localhost:3000'")

	const DAMAGE_RATE = 5.0
	var overlapping_mobs = $HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		hp -= DAMAGE_RATE * overlapping_mobs.size() * delta
		$ProgressBar.value = hp
		if hp <= 0.0:
			health_depleted.emit()
			# Désactive les contrôles du joueur
			set_process(false)
			# Arrête toutes les animations
			animations.stop()
			# Optionnel: Afficher un écran de Game Over ou réinitialiser le jeu
			end_menu.visible = true

	# Gestion du délai avant de quitter le jeu
	if Input.is_action_pressed("QuitJeu"):
		print("appuie sur Quit (Touche B8) effectue")
		await get_tree().create_timer(quit_delay).timeout
		JavaScriptBridge.eval("window.location.href='http://localhost:3000'")

	# Lancer un projectile
	if Input.is_action_just_pressed("fire"):
		var projectile_instance = projectile_scene.instantiate()
		projectile_instance.global_position = global_position
		projectile_instance.target = get_closest_mob()
		owner.add_child(projectile_instance)

func updateAnimation():
	if velocity == Vector2.ZERO:  # Si la vitesse est à 0, jouer l'animation d'attente (idle)
		animations.play("idle" + last_direction)
	else:
		var direction = last_direction
		if velocity.x < 0:
			direction = "_left"
			sprite.flip_h = false
		elif velocity.x > 0:
			direction = "_right"
			sprite.flip_h = true
		elif velocity.y < 0:
			direction = "_up"
		elif velocity.y > 0:
			direction = "_down"
		
		animations.play("run" + direction)
		

func _physics_process(delta):
	handleInput(delta)
	move_and_slide()
	updateAnimation()

# Fonction appelée lorsque la santé est épuisée
func _on_health_depleted():
	print("Game Over")
	# Rendre le menu de fin visible
	end_menu.visible = true
	# Désactiver les contrôles du joueur
	set_process(false)
	# Arrêter toutes les animations
	animations.stop()

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
