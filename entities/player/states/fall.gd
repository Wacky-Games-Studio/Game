extends State

@export var move_state: State
@export var idle_state: State
@export var jump_state: State
@export var slide_fall_animation_name: String

@onready var coyote_timer: Timer = %CoyoteTimer

var touching_spring := false

func enter() -> void:
	super()
	coyote_timer.start()

func process_input(_event: InputEvent) -> State:
	if InputBuffer.is_action_press_buffered("jump") and parent.is_on_wall_only():
		parent.spawn_jump_dust()
		return jump_state
		
	if Input.is_action_just_pressed("jump") and not coyote_timer.is_stopped() and parent.jumps_remaining > 0 and not touching_spring :
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
		parent.flip(dir < 0)
	else:
		parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.air_friction)

	parent.move_and_slide()
	
	touching_spring = false
	for i in parent.get_slide_collision_count():
		var collision: KinematicCollision2D = parent.get_slide_collision(i)
		if collision.get_collider().is_in_group("Spring"):
			touching_spring = true
			coyote_timer.stop()
	
	if parent.is_on_floor() and not touching_spring:
		parent.jumps_remaining = parent.max_jumps
		parent.spawn_dust(Player.ParticlesType.Land)
		parent.is_spring_jump = false
		if dir != 0:
			return move_state
		return idle_state
	
	return null
