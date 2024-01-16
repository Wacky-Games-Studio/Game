extends Node2D

@export var duration = 10.0
@onready var start: Marker2D = $Start
@onready var end: Marker2D = $End

func _ready() -> void:
	start_tween()

func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property($SawBladeMoving, "position", end.position, duration / 2)
	tween.tween_property($SawBladeMoving, "position", start.position, duration / 2)
