extends Node

const SAVE_PATH="res://info.js"

var high_scores=[]

func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.ModeFlags.READ)
		var parsed_data=JSON.parse_string(file.get_as_text())
		file.close()
	
		if parsed_data != null and typeof(parsed_data) == TYPE_DICTIONARY:
			high_scores = parsed_data.get("highscores", [])
		else:
			high_scores = []
	else:
		high_scores = []

func save_data():
	var game_data = {
		"highscores": high_scores
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.ModeFlags.WRITE)
	file.store_string(JSON.stringify(game_data, " "))
	file.close()
	
func add_score(name: String, score: int):
	if name.length() !=3:
		return false
	
	high_scores.append({"name": name.to_upper(), "score": score})
	high_scores.sort_custom(Callable(self, "_sort_by_score"))
	
	if high_scores.size() > 10:
		high_scores.pop_back()
	
	save_data()
	return true

func _sort_by_score(a, b):
	return b[1] - a[1]
