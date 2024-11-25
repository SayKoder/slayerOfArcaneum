extends Control

@onready var upgrade_button_1 = $VBoxContainer/UpgradeButton1 as Button
@onready var upgrade_button_2 = $VBoxContainer/UpgradeButton2 as Button
@onready var upgrade_button_3 = $VBoxContainer/UpgradeButton3 as Button

func _ready():
	upgrade_button_1.connect("pressed", Callable(self, "_on_upgrade_button_pressed").bind(1))
	upgrade_button_2.connect("pressed", Callable(self, "_on_upgrade_button_pressed").bind(2))
	upgrade_button_3.connect("pressed", Callable(self, "_on_upgrade_button_pressed").bind(3))

func _process(delta):
	if Input.is_action_just_pressed("StartGame"):
		if upgrade_button_1.has_focus():
			_on_upgrade_button_pressed(1)
		elif upgrade_button_2.has_focus():
			_on_upgrade_button_pressed(2)
		elif upgrade_button_3.has_focus():
			_on_upgrade_button_pressed(3)

func _on_upgrade_button_pressed(upgrade_type):
	var player = get_tree().get_first_node_in_group("player")
	match upgrade_type:
		1:
			player.fire_rate -= 0.1  # Example upgrade: Increase fire rate
		2:
			player.projectile_damage += 5  # Example upgrade: Increase projectile damage
		3:
			player.projectile_speed += 50  # Example upgrade: Increase projectile speed
	get_tree().paused = false
	queue_free()
