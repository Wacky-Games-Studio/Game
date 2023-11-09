extends State

@export var move_state: State
@export var idle_state: State
@export var fall_state: State

func enter() -> void:
	super()
	parent.jumps_remaining -= 1
	
	if not parent.is_on_wall_only():
		parent.velocity.y = parent.jump_velocity
	elif (parent.get_wall_normal().x < 0 and Input.is_action_pressed("walk_right")) or \
		 (parent.get_wall_normal().x > 0 and Input.is_action_pressed("walk_left")):
		parent.velocity = Vector2(parent.get_wall_normal().x * parent.wall_jump_pushback, parent.jump_velocity)

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.get_gravity() * delta
	
	if parent.velocity.y > 0:
		return fall_state
	
	if parent.ceiling_raycasts.right_outer and not parent.ceiling_raycasts.right_inner and \
	   not parent.ceiling_raycasts.left_inner and not parent.ceiling_raycasts.left_outer:
		parent.global_position.x -= parent.ceiling_raycast_push_offset
		print("aaaaa")
	elif parent.ceiling_raycasts.left_outer and not parent.ceiling_raycasts.left_inner and \
	   not parent.ceiling_raycasts.right_inner and not parent.ceiling_raycasts.right_outer:
		parent.global_position.x += parent.ceiling_raycast_push_offset
		print("bbbbbb")
		
	
	var dir = Input.get_axis("walk_left", "walk_right")
	
	if dir != 0:
		parent.velocity.x = lerp(parent.velocity.x, dir * parent.speed, parent.acceleration)
		parent.flip(dir < 0)
	else:
		parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.air_friction)
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if dir != 0:
			return move_state
		return idle_state
	
	return null
