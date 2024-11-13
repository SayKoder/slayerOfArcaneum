extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var speed = 100
@export var hp = 10
@onready var hurt_box: Area2D = $HurtBox
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if hurt_box:
		hurt_box.connect("hurt", Callable(self, "_on_HurtBox_hurt"))
	else:
		print("Error: HurtBox node not found")

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
	if hp <= 0:
		queue_free()

func _on_HurtBox_hurt(damage, angle, knockback):
	take_damage(damage)
	play_hurt()
