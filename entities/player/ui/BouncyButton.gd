extends Button

@export var scale_size: float = 1.5
@export var bounce_time: float = .1
@export var transition_type := Tween.TRANS_SINE
@export var should_grab_focus := false

var _start_scale: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneManager.connect("ScenePaused", paused)

	_start_scale = scale
	connect("mouse_entered", mouse_entered)

	connect("focus_entered", focus_entered)
	connect("focus_exited", focus_exit)

func _process(_delta):
	if pivot_offset == Vector2.ZERO:
		pivot_offset = size / 2
		print(size)

func mouse_entered():
	grab_focus()

func focus_entered():
	if disabled: return
	grab_focus()
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "scale", _start_scale * scale_size, bounce_time).set_trans(transition_type)

func focus_exit():
	if has_focus() or disabled: return
	var tween = get_tree().create_tween().set_trans(transition_type)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "scale", _start_scale, bounce_time)

func paused():
	if should_grab_focus:
		grab_focus()