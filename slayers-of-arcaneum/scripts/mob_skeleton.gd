extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var speed = 100
@onready var hurt_box: Area2D = $HurtBox
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var max_hp = 10
var hp

signal died

func _ready() -> void:
	hp = max_hp
	if hurt_box:
		hurt_box.connect("hurt", Callable(self, "_on_HurtBox_hurt"))
	else:
		print("Error: HurtBox node not found")
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

func _on_HurtBox_hurt(damage, angle, knockback):
	take_damage(damage)
	play_hurt()

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		emit_signal("died")
		die()

func die():
	queue_free()

func _on_Died():
	print("The mob has died")
