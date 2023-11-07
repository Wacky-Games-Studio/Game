extends State

@export var idle: State

var _return_var: State = null

func enter():
	super()
	
	await parent.animator.animation_finished
	_return_var = idle

func process_frame(delta: float) -> State:
	return _return_var
