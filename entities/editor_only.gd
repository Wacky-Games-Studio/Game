@tool
extends Node

func _ready():
	if Engine.is_editor_hint() == false:
		queue_free()
