extends Control

@onready var speed_label = $HBoxContainer/SpeedLabel
@onready var health_label = $HBoxContainer/HealthLabel
@onready var playtime_label = $HBoxContainer.get_node_or_null("PlaytimeLabel")
@onready var damage_label = $HBoxContainer/DamageLabel

var player
var playtime = 0.0

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("Player not found")
		return

	if playtime_label == null:
		print("PlaytimeLabel node not found")

func _process(delta):
	if player:
		speed_label.text = "Speed: %d" % player.speed

		playtime += delta
		if playtime_label:
			playtime_label.text = "Playtime: %.2f" % playtime
		damage_label.text = "Projectile Damage: %d" % player.projectile_damage
