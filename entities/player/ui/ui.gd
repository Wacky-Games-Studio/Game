extends CanvasLayer

@onready var pause_menu = %PauseMenu
@onready var quit_modal = %QuitPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pause_menu.visible = true
	#quit_modal.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if quit_modal.visible: return

	if Input.is_action_just_pressed("pause"):
		if not visible: pause()
		else: resume()

func pause():
	SceneManager.pause_scene()
	get_tree().paused = true
	visible = true

func resume():
	SceneManager.start_scene()
	get_tree().paused = false
	visible = false

func _on_resume_button_pressed():
	resume()

func _on_settings_button_pressed():
	pass # Replace with function body.

func _on_quit_button_pressed():
	pause_menu.disable()
	quit_modal.focus()

func _on_quit_panel_quit_modal_exited():
	pause_menu.enable()
	pause()
