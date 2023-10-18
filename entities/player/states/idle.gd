extends State

@export var walk_state: State
@export var jump_state: State

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	
	if Input.get_axis("walk_left", "walk_right") != 0:
		return walk_state
	
	
	return null

func process_physics(delta: float) -> State:
	print("idle")
	parent.velocity.y += gravity * delta
	parent.velocity.x = lerp(parent.velocity.x, 0.0, friction)
	
	parent.move_and_slide()
	
	return null
