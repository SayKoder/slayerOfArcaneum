extends Area2D

signal hurt(damage, angle, knockback)

@onready var collision = $CollisionShape2D

func _ready() -> void:
	if collision:
		connect("area_entered", Callable(self, "_on_area_entered"))
	else:
		print("Error: CollisionShape2D node not found")

func _on_area_entered(area):
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			var damage = area.damage
			var angle = Vector2.ZERO
			var knockback = 1
			if not area.get("angle") == null:
				angle = area.angle
			if not area.get("knockback_amount") == null:
				knockback = area.knockback_amount

			emit_signal("hurt", damage, angle, knockback)
