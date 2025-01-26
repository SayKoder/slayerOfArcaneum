extends Node# Assurez-vous que ce chemin pointe vers le bon noeud

var current_score: int = 0

func game_over_with_name(player_name: String):
	# Vérifiez si le score peut être enregistré
	if GameStats.high_scores.size() < 10 or current_score > GameStats.high_scores[-1]["score"]:
		show_name_input_menu()
	else:
		_show_high_scores()

	if GameStats.add_score(player_name, current_score):
		print("Score enregistré !")
	else:
		print("Score non suffisant pour être enregistré.")
	_show_high_scores()

func _show_high_scores():
	# Affiche les meilleurs scores
	print(GameStats.get_high_scores_string())

func show_name_input_menu():
	# Instancie une scène pour l'entrée du nom
	var menu_scene = preload("res://scenes/menu_save.tscn")
	var menu_instance = menu_scene.instantiate()
	add_child(menu_instance)
	menu_instance.connect("name_entered", Callable(self, "_on_name_entered"))

func _on_name_entered(name: String):
	print("Nom entré :", name)
	game_over_with_name(name)
