extends AudioStreamPlayer2D

var music_menu = preload("res://assets/audio/The Last Stand.mp3")
var music_wave1 = preload("res://assets/audio/The Last Stand.mp3")

func _ready():
	# Si la musique n'est pas déjà en train de jouer, on la lance
	if not self.playing:
		self.play()

func change_music(scene_name):
	match scene_name:
		"menu_principal":
			stream = music_menu
		"wave1":
			stream = music_wave1
	play()
