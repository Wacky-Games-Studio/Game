extends State

@export var idle_state: State
@export var jump_state: State

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
		
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	var dir = Input.get_axis("walk_left", "walk_right")
	if dir != 0:
		parent.velocity.x = lerp(parent.velocity.x, dir * speed, acceleration)
	else:
		return idle_state
	

	parent.move_and_slide()
	
	return null
	#if Input.is_action_just_pressed("jump") and is_on_floor():
	#	velocity.y = jump_speed
