extends Node

@export var speed = 400
@export var projectile_speed = 350
@export var projectile_damage = 30
@export var projectile_fire_rate = 1.0
@export var hp = 100
@export var max_hp = 100

func reset():
	speed = 150
	projectile_damage = 10
	projectile_fire_rate = 1.0
	hp = 100
	max_hp = 100
