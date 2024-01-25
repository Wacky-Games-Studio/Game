@tool
extends FlowContainer

@onready var load_dialog: FileDialog = $"../../LoadFileDialog"
@onready var save_dialog: FileDialog = $"../../SaveFileDialog"
@onready var load_previous_dialog: FileDialog = $"../../LoadSaveDialog"

var paths: Array = []

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
		return
	
	var button := TextureButton.new()
	button.texture_normal = preview
	button.stretch_mode = TextureButton.STRETCH_SCALE
	button.custom_minimum_size = Vector2(128, 128)
	button.toggle_mode = true
	
	add_child(button)

func _on_add_scene_pressed():
	load_dialog.popup_centered_ratio(.2)

func _on_reload_previews_pressed():
	for child in get_children():
		child.queue_free()
	
	for path in paths:
		_load_preview(path)

func _on_save_pressed():
	save_dialog.popup_centered_ratio(.2)


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
	load_previous_dialog.popup_centered_ratio(.2)
