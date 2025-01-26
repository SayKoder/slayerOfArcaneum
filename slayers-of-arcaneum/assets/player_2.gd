extends CharacterBody2D

@onready var sprite = $Sprite2D
@export var speed: int = 150.0
@onready var animations = $AnimationPlayer

var last_direction = "_down" # Par défaut, le personnage regarde vers le bas

func handleInput():
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
	handleInput()
	move_and_slide()
	updateAnimation()
