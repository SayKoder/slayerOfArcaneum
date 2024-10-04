extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var speed = 100
@export var hp = 10

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

	

# Fonction appelée à chaque frame physique
func _physics_process(_delta):
	# Calculer la direction vers le joueur
	var direction = global_position.direction_to(player.global_position)
	
	# Appliquer la vitesse au mob pour qu'il se déplace vers le joueur
	velocity = direction * speed
	move_and_slide()

	# Jouer l'animation de déplacement
	play_run()

	# Flip le sprite en fonction de la direction de déplacement
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true

# Fonction pour jouer l'animation de course
func play_run():
	animated_sprite.play("running")

# Fonction pour jouer l'animation quand le mob est blessé
func play_hurt():
	animated_sprite.play("hurt")


func take_damage():
	hp -= 1
	
	if hp == 0:
		queue_free()
