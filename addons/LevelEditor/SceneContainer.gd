@tool
extends FlowContainer

@export var scene_button: PackedScene
@export var error_texture: Texture2D

@onready var load_dialog: FileDialog = $"../../LoadFileDialog"
@onready var save_dialog: FileDialog = $"../../SaveFileDialog"
@onready var load_previous_dialog: FileDialog = $"../../LoadSaveDialog"

var paths: Array = []
var buttons: Array[SceneButton] = []
var clicked_button: SceneButton

func _load_preview(path: String):
	var previewer: EditorResourcePreview = EditorInterface.get_resource_previewer()
	previewer.queue_resource_preview(path, self, "_on_preview_done", null)

func _on_file_dialog_file_selected(path):
	if path in paths:
		print("Path is already loaded")
		return
	
	_load_preview(path)
	
func _on_preview_done(path: String, preview: Texture2D, thumbnail_preview: Texture2D, userdata: Variant):
	if preview == null:
		print("Could not create a preview")
		preview = error_texture
	
	var button: SceneButton = scene_button.instantiate()
	button.init(preview, path)
	button.connect("scene_clicked", _on_scene_clicked, 2)
	
	buttons.push_back(button)
	add_child(button)

func _on_scene_clicked(button: SceneButton, value: bool):
	# value = false
	if value == false:
		clicked_button = null
		return
	
	# value = true
	if clicked_button != null:
		clicked_button.clicked = false
	clicked_button = button

func _on_add_scene_pressed():
	load_dialog.popup_centered_ratio()

func _on_reload_previews_pressed():
	for child in get_children():
		child.queue_free()
	paths = []
	
	for path in paths:
		_load_preview(path)

func _on_save_pressed():
	save_dialog.popup_centered_ratio()


func _on_save_file_dialog_file_selected(path):
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(paths))
	file.close()


func _on_load_save_dialog_file_selected(path):
	var file := FileAccess.open(path, FileAccess.READ)
	paths = JSON.parse_string(file.get_as_text(true))
	file.close()
	
	for scene_path in paths:
		_load_preview(scene_path)


func _on_load_previous_pressed():
	load_previous_dialog.popup_centered_ratio()

func _on_clear_pressed():
	paths = []
	for child in get_children():
		child.queue_free()
