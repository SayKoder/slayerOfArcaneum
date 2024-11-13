extends Area2D

@export var speed = 300
@export var damage = 1
var direction = Vector2.ZERO
var target = null  # Declare the target variable

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableHitBoxTimer

func _ready():
	# Set the initial direction towards the target
	if target:
		direction = (target.global_position - global_position).normalized()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta):
	# Move the projectile in the direction of the target
	if target:
		direction = (target.global_position - global_position).normalized()
		position += direction * speed * delta

		# Optionally, you can add code to handle what happens when the projectile reaches the target
		if position.distance_to(target.global_position) < 10:
			queue_free()  # Remove the projectile from the scene

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()  # Remove the projectile from the scene after hitting the target

func tempdisable():
	collision.call_deferred("set", "disabled", true)
	disableTimer.start()

func _on_disable_hit_box_timer_timeout():
	collision.call_deferred("set", "disabled", false)
