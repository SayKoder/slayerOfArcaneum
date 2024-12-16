extends Node

@export var speed = 150
@export var projectile_damage = 10
@export var projectile_fire_rate = 1.0  # Added this line
@export var hp = 150
@export var max_hp = 100

func reset():
	speed = 150
	projectile_damage = 10
	projectile_fire_rate = 1.0  # Added this line
	hp = 150
	max_hp = 100
