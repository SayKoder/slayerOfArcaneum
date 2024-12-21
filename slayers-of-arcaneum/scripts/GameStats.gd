extends Node

var player_name = "Gui"
var score = 0

@onready var http_request = HTTPRequest.new()

func reset():
	score = 0

func _ready():
	# Ajouter le HTTPRequest si nécessaire
	if not http_request.is_inside_tree():
		add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))

# Fonction principale pour sauvegarder le score localement
func save_score():
	var file_path = "user://info.json"
	print("Chemin absolu : ", ProjectSettings.globalize_path(file_path))
	print("Tentative de sauvegarde dans :", file_path)

	# Charger ou créer le fichier
	var info = load_or_initialize_file(file_path)

	# Mettre à jour les scores
	var new_highscore = {"name": player_name, "score": score}
	info["highscores"] = update_highscores(info.get("highscores", []), new_highscore)

	# Sauvegarder les scores mis à jour
	save_to_file(file_path, info)

	# Envoyer le score au serveur
	send_score_to_server(new_highscore)

# Charger ou initialiser le fichier info.json
func load_or_initialize_file(file_path: String) -> Dictionary:
	if not FileAccess.file_exists(file_path):
		print("Le fichier info.json n'existe pas. Création d'un fichier par défaut.")
		var default_content = {
								  "name": "Slayers Of Arcaneum",
								  "description": "Les Démons Primordiaux ont envahi les Cieux...",
								  "creator": "Guillaume ROBERT, Kévin TISSIER, Carl HEINTZ",
								  "year": 2024,
								  "type": "Arcade Survival Horde",
								  "players": "1player",
								  "highscores": [],
								  "catchphrase": "Les Démons Primordiaux...",
								  "playcount": 1
							  }
		save_to_file(file_path, default_content)
		return default_content

	var file = FileAccess.open(file_path, FileAccess.READ)
	var data = file.get_as_text()
	file.close()

	if data.strip_edges() == "":
		print("Le fichier est vide. Initialisation avec des données par défaut.")
		return {"highscores": []}

	var json = JSON.new()
	if json.parse(data) == OK:
		return json.get_data()
	else:
		print("Erreur lors du parsing JSON. Retour des données par défaut.")
		return {"highscores": []}

# Sauvegarder dans le fichier JSON
func save_to_file(file_path: String, data: Dictionary):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.flush()
	file.close()

# Fonction pour comparer les scores
func compare_scores(a: Dictionary, b: Dictionary) -> int:
	return b["score"] - a["score"]

# Mise à jour des scores
func update_highscores(highscores: Array, new_score: Dictionary) -> Array:
	# Vérifie si un score identique existe déjà
	for existing_score in highscores:
		if existing_score["score"] == new_score["score"]:
			print("Score déjà présent, non ajouté :", new_score)
			return highscores
	# Ajoute et trie les scores
	highscores.append(new_score)

	highscores.sort_custom(Callable(self, "compare_scores"))

	# Limite la liste à 10 éléments
	if highscores.size() > 10:
		highscores = highscores.slice(0, 10)

	print("Liste mise à jour :", highscores)
	return highscores

# Envoi des données au serveur
func send_score_to_server(score_data: Dictionary):
	var url = "http://localhost:3000/api?game=SlayersOfArcaneum"
	print("Envoi des données à :", url)

	var json = JSON.stringify(score_data)
	print("Payload JSON :", json)

	var error = http_request.request(url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, json)
	if error != OK:
		print("Erreur lors de l'envoi de la requête :", error)

# Callback pour traiter la réponse HTTP
func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		print("Score envoyé avec succès :", body.get_string_from_utf8())
	else:
		print("Erreur lors de l'envoi au serveur :", response_code, "Message :", body.get_string_from_utf8())

# Fonction pour obtenir le score
func get_score() -> int:
	return score
