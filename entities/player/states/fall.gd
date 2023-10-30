extends State

@export var move_state: State
@export var idle_state: State
@export var jump_state: State
@export var slide_fall_animation_name: String

@onready var coyote_timer: Timer = %CoyoteTimer

func enter() -> void:
	super()
	coyote_timer.start()

func process_input(event: InputEvent) -> State:
	if InputBuffer.is_action_press_buffered("jump") and parent.is_on_wall_only():
		return jump_state
		
	if Input.is_action_just_pressed("jump") and not coyote_timer.is_stopped() and parent.jumps_remaining > 0:
		return jump_state

	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.get_gravity() * delta
	
	var dir = Input.get_axis("walk_left", "walk_right")
	
	if parent.is_on_wall_only() and \
		((parent.get_wall_normal().x < 0 and Input.is_action_pressed("walk_right")) or \
		(parent.get_wall_normal().x > 0 and Input.is_action_pressed("walk_left"))):
		parent.animator.play(slide_fall_animation_name)
		parent.velocity.y = min(parent.velocity.y, parent.wall_slide_gravity)
	elif parent.animator.current_animation != animation_name:
		parent.animator.play(animation_name)
	
	if dir != 0:
		parent.velocity.x = lerp(parent.velocity.x, dir * parent.speed, parent.acceleration)
		parent.sprite.flip_h = dir < 0
	else:
		parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.air_friction)

	parent.move_and_slide()
	
	if parent.is_on_floor():
		parent.jumps_remaining = parent.max_jumps
		parent.spawn_land_dust()
		if dir != 0:
			return move_state
		return idle_state
	
	return null
