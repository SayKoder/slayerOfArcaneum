extends CharacterBody2D
class_name Shadow

@export var speed = 200
@export var hp = 25
@export var damage = 30
@onready var health_bar: ProgressBar = $ProgressBar
signal died

func _ready():
	if health_bar:
		health_bar.max_value = hp
		health_bar.value = hp
	else:
		print("Error: ProgressBar node not found")

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (player.global_position - global_position).normalized()
		position += direction * speed * delta

func take_damage(damage):
	hp -= damage
	if health_bar:
		health_bar.value = hp  
	print("Damage taken: ", damage, " | Remaining HP: ", hp)
	if hp <= 0:
		emit_signal("died", 10)  
		die()

func die():
	queue_free()

func _on_Died():
	print("The shadow mob has died")
