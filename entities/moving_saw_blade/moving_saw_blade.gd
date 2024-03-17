@icon("res://icons/sawblade_moving.svg")
class_name MovingSawblade
extends Path2D

@export var loop := true
@export var loop_back := true
@export var seconds_to_complete := 1.0
@export var draw_rail := true
@export var rail_color_moduate := Color.WHITE

@onready var animation: AnimationPlayer = $AnimationPlayer

var anim: String

# Called when the node enters the scene tree for the first time.
func _ready():
	anim = "move_back" if loop_back else "move"
	animation.play(anim)
	animation.speed_scale = 1 / seconds_to_complete
	
	animation.animation_finished.connect(_on_finished)
	
	$RailLine.visible = draw_rail
	$RailLine.closed = loop_back == false
	$RailLine.default_color = rail_color_moduate

func _on_finished(_name: String):
	animation.play(anim)
