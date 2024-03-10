extends Control

@onready var play_button: Button = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/PlayButton

# Called when the node enters the scene tree for the first time.
func _ready():
	play_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	SceneManager.change_level_specific("res://scenes/intro.tscn", false, true)

func _on_settings_button_pressed():
	pass # Replace with function body.

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

