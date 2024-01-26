extends Path2D

@export var loop := true
@export var loop_back := true
@export var seconds_to_complete := 1.0

@onready var animation: AnimationPlayer = $AnimationPlayer

var anim: String

# Called when the node enters the scene tree for the first time.
func _ready():
	anim = "move_back" if loop_back else "move"
	animation.play("move")
	animation.speed_scale = seconds_to_complete
	
	animation.animation_finished.connect(_on_finished)

func _on_finished(_name: String):
	animation.play("move")
