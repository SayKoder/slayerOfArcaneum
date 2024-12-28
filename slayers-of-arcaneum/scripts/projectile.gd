extends Area2D

@export var speed = 200
@export var damage = 1
var target: Node2D

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var collision = $CollisionShape2D

func _ready():
	pass

func _process(delta):
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		position += direction * speed * delta
	else:
		queue_free()  

func _on_body_entered(body):
	print("Collision detected with: ", body)
	if body.has_method("take_damage"):
		print("Calling take_damage on: ", body)
		body.take_damage(damage)
	else:
		print("No take_damage method found on: ", body)
	queue_free()  

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func set_damage(new_damage):
	damage = new_damage
	print("Projectile damage set to %d" % damage)
