extends Panel

signal quit_modal_exited

@onready var yes_button: Button = $VBoxContainer/HBoxContainer/YesButton
@onready var no_button: Button = $VBoxContainer/HBoxContainer/NoButton

func focus():
	visible = true
	yes_button.grab_focus()

func _process(_delta):
	if visible == false: return

	if Input.is_action_just_pressed("ui_cancel"):
		_on_ok_button_pressed()
	
	if Input.is_action_just_pressed("ui_left"):
		yes_button.grab_focus()
	if Input.is_action_just_pressed("ui_right"):
		no_button.grab_focus()

func _on_ok_button_pressed():
	visible = false
	emit_signal("quit_modal_exited")


func _on_quit_button_pressed():
	print("please quit")
	get_tree().quit()