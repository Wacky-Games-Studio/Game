extends Control

@onready var resume_button: Button = $Panel/HBoxContainer/VBoxContainer/Panel/VBoxContainer/ResumeButton
@onready var settings_button: Button = $Panel/HBoxContainer/VBoxContainer/Panel/VBoxContainer/SettingsButton
@onready var quit_button: Button = $Panel/HBoxContainer/VBoxContainer/Panel/VBoxContainer/QuitButton

func disable():
	hide()
	show()
	resume_button.disabled = true
	settings_button.disabled = true
	quit_button.disabled = true

func enable():
	resume_button.disabled = false
	settings_button.disabled = false
	quit_button.disabled = false