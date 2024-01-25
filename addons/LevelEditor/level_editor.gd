@tool
extends EditorPlugin

var dock: Control

func _enter_tree():
	# Initialization of the plugin goes here.
	dock = preload("res://addons/LevelEditor/dock.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)
	pass

func _process(delta):
	var mouse_pos: Vector2 = EditorInterface.get_editor_viewport_2d().get_parent().get_local_mouse_position()
	var size_of_2d_viewport := EditorInterface.get_editor_viewport_2d().size
	
	var mouse_rect := Rect2(mouse_pos, Vector2.ONE)
	var viewport_rect := Rect2(Vector2.ZERO, size_of_2d_viewport)
	
	if not mouse_rect.intersects(viewport_rect):
		return
	
	var mouse_local_in_editor: Vector2 = EditorInterface.get_editor_viewport_2d().get_mouse_position()


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_control_from_docks(dock)
	dock.free()
