extends Node

@export var speed = 200
@export var projectile_speed = 350
@export var projectile_damage = 10
@export var projectile_fire_rate = 1.0
@export var hp = 150
@export var max_hp = 150
@export var can_dash: bool = false
@export var bouncing_bullets: bool = false

func reset():
	speed = 200
	projectile_damage = 10
	projectile_fire_rate = 1.0
	hp = 150
	max_hp = 150
	can_dash = false
	bouncing_bullets = false
