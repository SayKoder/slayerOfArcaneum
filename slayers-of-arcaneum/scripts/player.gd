extends CharacterBody2D

@export var speed = 150
var hp = 100


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_attacking = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	
	# Autoriser les mouvements même si le personnage attaque
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	# Flip the sprite based on movement direction
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true

	# Si on n'est pas en train d'attaquer, jouer les animations de déplacement
	if not is_attacking:
		if velocity.length() == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("running")
	
	# Normaliser la vitesse si le personnage se déplace
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
	
	# Gestion du délai avant de quitter le jeu
	if Input.is_action_pressed("quit_game"):
		print("appuie sur Quit (Touche B8) effectue")
		JavaScriptBridge.eval("window.location.href='http://localhost:3000'")



func _on_hurt_box_hurt(damage):
	hp -= damage
	print (hp)
