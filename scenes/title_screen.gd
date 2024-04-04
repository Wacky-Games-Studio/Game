extends Control

@onready var play_button: Button = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/PlayButton
@onready var continue_button: Button = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/ContinueButton
@onready var settings_button: Button = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/SettingsButton

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists("user://savegame.save"):
		continue_button.visible = true
		play_button.visible = false
		continue_button.grab_focus()
	else:
		continue_button.visible = false
		play_button.visible = true
		play_button.grab_focus()

	Settings.get_children()[0].connect("just_hidden", settings_hidden)

func _on_play_button_pressed():
	SceneManager.change_level_specific("res://scenes/intro.tscn", false, true)

func _on_settings_button_pressed():
	Settings.show()
	
func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_continue_button_pressed():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)

	var file = save_file.get_as_text()
	save_file.close()

	var regex = RegEx.new()
	regex.compile("\\d+")

	var result = regex.search(file)
	if result:
		var status: bool = await SceneManager.change_level_with_status(result.get_string())
		if not status:
			continue_button.visible = false
			play_button.visible = true
			play_button.grab_focus()		

	else:
		continue_button.visible = false
		play_button.visible = true
		play_button.grab_focus()

func settings_hidden():
	settings_button.grab_focus()
