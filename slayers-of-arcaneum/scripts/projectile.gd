extends Area2D

@export var speed = 300
@export var damage = 1
var target: Node2D

@onready var collision = $CollisionShape2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta):
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		position += direction * speed * delta
	else:
		queue_free()  # Remove the projectile if the target is not valid

func _on_body_entered(body):
	print("Collision detected with: ", body)
	if body.has_method("take_damage"):
		print("Calling take_damage on: ", body)
		body.take_damage(damage)
	else:
		print("No take_damage method found on: ", body)
	queue_free()  # Remove the projectile from the scene after hitting the target

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
