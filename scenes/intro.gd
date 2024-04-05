extends Node2D

@export var screen_size := 480
@export var start_pos := 240
@export var end_pos := 300

@onready var player: Player = $Player
@onready var normal: Sprite2D = $Normal
@onready var fucked: Sprite2D = $Fucked

func _ready():
	player.disable_walljump()
	player.disable_canvas_modulate()
	var duckIndex = AudioServer.get_bus_index("Duck")
	AudioServer.set_bus_bypass_effects(duckIndex, true)

func _exit_tree():
	var duckIndex = AudioServer.get_bus_index("Duck")
	AudioServer.set_bus_bypass_effects(duckIndex, false)

func _process(_delta):
	if player.position.x > screen_size: return
	var val = smoothstep(start_pos, end_pos, player.position.x)

	normal.modulate.a = 1 - val
	fucked.modulate.a = val

func _smoothstep(edge0: float, edge1: float, x: float):
	x = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0)
	return x * x * (3.0 - 2.0 * x)