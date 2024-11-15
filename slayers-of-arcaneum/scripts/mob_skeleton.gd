extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var speed = 100
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var max_hp = 5
var hp

@onready var health_bar: ProgressBar = $ProgressBar  # Reference to the ProgressBar node

signal died

func _ready() -> void:
	hp = max_hp
	health_bar.max_value = max_hp  # Set the max value of the health bar
	health_bar.value = hp  # Initialize the health bar value
	connect("died", Callable(self, "_on_Died"))

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	play_run()
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true

func play_run():
	animated_sprite.play("running")

func play_hurt():
	animated_sprite.play("hurt")

func take_damage(damage):
	hp -= damage
	health_bar.value = hp  # Update the health bar value
	print("Damage taken: ", damage, " | Remaining HP: ", hp)
	if hp <= 0:
		emit_signal("died")
		die()

func die():
	queue_free()

func _on_Died():
	print("The mob has died")
