extends Node

@export var intensity: float = 0.0 : set = set_intensity, get = get_intensity

@onready var music_player: OvaniPlayer = $OvaniPlayer

var _intensity := 0.0

func get_intensity() -> float:
	return _intensity

func set_intensity(value: float):
	music_player.Intensity = clampf(value, 0.0, 1.0)
	_intensity = value
