extends RichTextLabel

@export var text_color: Color

func _ready():
	modulate=text_color
