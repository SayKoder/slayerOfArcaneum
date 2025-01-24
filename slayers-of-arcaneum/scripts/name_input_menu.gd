extends Control

signal name_entered(name)

@onready var GameStats = get_tree().root.get_node("/root/GameStats")
@onready var Main = get_tree().root.get_node("/root/Main")

@onready var letter_labels = [
	$Panel/HBoxContainer/Label,
	$Panel/HBoxContainer/Label2,
	$Panel/HBoxContainer/Label3
]
@onready var validate_button=$Panel/Button as Button

var current_position := 0
var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
var selected_letters = ["A", "A", "A"]

func _ready():
	if Main == null:
		print("Erreur : le noeuf 'Main' est introuvable")
		return
	if GameStats == null:
		print("Erreur : le noeuf 'ScoreManager' est introuvable")
	display_high_scores()
	if GameStats.high_scores.size() > 0 and GameStats.score <= GameStats.high_scores[-1]["score"] and GameStats.high_scores.size() == 10:
		$Panel/HBoxContainer.hide()
		$Panel/Name.hide()
	else:
		$Panel/HBoxContainer.show()
		$Panel/Name.show()
	
	set_focus_mode(Control.FOCUS_ALL)
	grab_focus()
	set_process_unhandled_input(true)
	validate_button.connect("pressed", Callable(self, "_on_validate_pressed"))
	update_letters()

func _unhandled_input(event):
	if event is InputEventJoypadMotion or event is InputEventJoypadButton:
		handle_arcade_controls(event)

func handle_arcade_controls(event):
	print("Input détecté : ", event)
	if event.is_action_pressed("move_up"):
		change_letter(current_position, 1)
	elif event.is_action_pressed("move_down"):
		change_letter(current_position, -1)
	elif event.is_action_pressed("move_right"):
		current_position = (current_position + 1) % 3
		update_letters()
	elif event.is_action_pressed("move_left"):
		current_position = (current_position - 1) % 3
		update_letters()
	elif event.is_action_pressed("attack_1"):
		_on_validate_pressed()

func change_letter(index, direction):
	var current_letter = selected_letters[index]
	var current_index = alphabet.find(current_letter)
	var new_index = (current_index + direction) % alphabet.size()
	if new_index < 0:
		new_index = alphabet.size() - 1  # Boucle vers la fin de l'alphabet
	selected_letters[index] = alphabet[new_index]
	update_letters()

func update_letters():
	for i in range(3):
		letter_labels[i].text = selected_letters[i]
		letter_labels[i].modulate = Color(1, 1, 1)  # Couleur normale
	letter_labels[current_position].modulate = Color(1, 0, 0)  # Couleur pour la lettre active

func _on_validate_pressed():
	var name = "".join(selected_letters)
	emit_signal("name_entered", name)
	queue_free()

func display_high_scores():
	var high_scores_container = $Panel/HighScores
	
	for child in high_scores_container.get_children():
		high_scores_container.remove_child(child)
		child.queue_free()
	
	for score_entry in GameStats.high_scores:
		var score_label = Label.new()
		score_label.text = "%s: %d" % [score_entry["name"], score_entry["score"]]
		high_scores_container.add_child(score_label)
