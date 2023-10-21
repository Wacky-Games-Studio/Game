extends CPUParticles2D

var _timer := 0.0
var _max_timer: float

func _ready():
	emitting = true
	_max_timer = lifetime

func _process(delta):
	_timer += delta
	if _timer > lifetime:
		queue_free()
