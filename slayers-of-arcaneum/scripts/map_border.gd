# MapBorders.gd
extends StaticBody2D

func _ready():
	# Define the borders of the map
	var top_border = CollisionShape2D.new()
	top_border.shape = RectangleShape2D.new()
	top_border.shape.extents = Vector2(200, 10)  # Adjust the size as needed
	top_border.position = Vector2(200, 10)  # Adjust the position as needed
	add_child(top_border)

	var bottom_border = CollisionShape2D.new()
	bottom_border.shape = RectangleShape2D.new()
	bottom_border.shape.extents = Vector2(200, 10)  # Adjust the size as needed
	bottom_border.position = Vector2(200, 590)  # Adjust the position as needed
	add_child(bottom_border)

	var left_border = CollisionShape2D.new()
	left_border.shape = RectangleShape2D.new()
	left_border.shape.extents = Vector2(10, 200)  # Adjust the size as needed
	left_border.position = Vector2(10, 200)  # Adjust the position as needed
	add_child(left_border)

	var right_border = CollisionShape2D.new()
	right_border.shape = RectangleShape2D.new()
	right_border.shape.extents = Vector2(10, 200)  # Adjust the size as needed
	right_border.position = Vector2(200, 20)  # Adjust the position as needed
	add_child(right_border)
