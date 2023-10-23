extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ATTACK_DISTANCE = 100.0  # Adjust this distance as needed
@onready var player = $"../Player"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target = null

func _ready():
	target = get_node("/root/")  # Replace with the path to your player character in the scene

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	var player_distance = player.global_position.distance_to(global_position)

	if player_distance < ATTACK_DISTANCE:
		move_toward_player()
	else:
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	#move_and_slide(velocity)

func move_toward_player():
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * SPEED
	# You can also add logic for vertical movement (jumping or falling) if needed.
