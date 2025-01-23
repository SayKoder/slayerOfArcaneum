extends Area2D

@onready var collision_shape = $CollisionShape2D
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	if collision_shape:
		collision_shape.disabled = false
	player = get_node("/root/wave1/Player")
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))
	if not is_connected("body_exited", Callable(self, "_on_body_exited")):
		connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	print("Body entered: %s" % body.name)
	if body.name == "Player" and player:
		print("Player entered collision area")
		player.is_colliding_with_wall = true

func _on_body_exited(body):
	print("Body exited: %s" % body.name)
	if body.name == "Player" and player:
		print("Player exited collision area")
		player.is_colliding_with_wall = false
