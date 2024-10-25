extends CharacterBody2D

@export var speed = 300
@export var damage = 1
@export var projectile_scene: PackedScene
var target: CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

func _process(delta):
	if target:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * speed

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		body.take_damage(damage)
		queue_free()
		
