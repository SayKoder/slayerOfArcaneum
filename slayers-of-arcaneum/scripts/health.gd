extends Node

@export var max_hp = 10
var hp

signal died

func _ready() -> void:
	hp = max_hp

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		emit_signal("died")
		die()

func die():
	queue_free()