extends CharacterBody2D
class_name MobSkeleton

@onready var player = get_tree().get_first_node_in_group("player")
@export var speed = 170
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var max_hp = 5
var hp


@onready var health_bar: ProgressBar = $ProgressBar  # Reference to the ProgressBar node
@onready var collision_area: Area2D = $Area2D

signal died

var is_attacking = false
var is_in_collision_with_player = false

func _ready() -> void:
	hp = max_hp
	health_bar.max_value = max_hp  # Set the max value of the health bar
	health_bar.value = hp  # Initialize the health bar value
	
	collision_area.body_entered.connect(_on_body_entered)
	collision_area.body_exited.connect(_on_body_exited)
	
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(_delta):
	if hp > 0:
		if is_attacking:
			velocity = Vector2.ZERO
		else:
			var direction = global_position.direction_to(player.global_position)
			velocity = direction * speed
			move_and_slide()
			play_run()
			
		if velocity.x > 0:
			animated_sprite.flip_h = false
		elif velocity.x < 0:
			animated_sprite.flip_h = true

func play_run():
	if not is_attacking:
		animated_sprite.play("running")

func play_hurt():
	animated_sprite.play("hurt")
	
func play_death():
	animated_sprite.play("death")
	velocity = Vector2.ZERO

func play_attack():
	animated_sprite.play("attack")
	is_attacking = true

func take_damage(damage):
	hp -= damage
	play_hurt()
	health_bar.value = hp  
	print("Damage taken: ", damage, " | Remaining HP: ", hp)
	if hp <= 0:
		emit_signal("died", 10)  
		disable_collisions()
		play_death()

func disable_collisions():
	collision_layer = 0
	collision_mask = 0

func _on_animation_finished():
	if animated_sprite.animation == "death":
		fade_out_and_disappear()
	elif animated_sprite.animation == "attack":
		if is_in_collision_with_player:
			play_attack()
		else:
			is_attacking = false
			play_run()

func fade_out_and_disappear():
	var fade_timer = Timer.new()
	fade_timer.wait_time = 0.1
	fade_timer.one_shot = true
	fade_timer.connect("timeout", Callable(self, "_on_fade_step"))
	add_child(fade_timer)
	fade_timer.start()
	
func _on_fade_step():
	modulate.a -= 0.1
	if modulate.a <= 0:
		queue_free()
	else:
		fade_out_and_disappear()

func _on_body_entered(body):
	if body.is_in_group("player"):
		is_in_collision_with_player = true
		print("Collision detected with player!")
		play_attack()

# Détecte la sortie de collision avec le joueur
func _on_body_exited(body):
	if body.is_in_group("player"):
		is_in_collision_with_player = false
		print("Player left collision area.")
		is_attacking = false
		play_run()
