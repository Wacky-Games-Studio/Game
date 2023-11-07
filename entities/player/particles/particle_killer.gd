extends CPUParticles2D

var _timer := 0.0
var _max_timer: float

func _ready() -> void:
	_max_timer = lifetime

func _process(delta) -> void:
	if not emitting:
		return

	_timer += delta
	if _timer > lifetime:
		queue_free()
