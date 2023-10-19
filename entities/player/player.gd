class_name Player
extends CharacterBody2D

@export var speed := 200
@export var jump_speed := -450
@export var wall_jump_pushback := -225
@export var gravity := 2000
@export var wall_slide_gravity := 100
@export var max_jumps := 1
@export_range(0.0, 1.0) var friction := 0.3
@export_range(0.0 , 1.0) var acceleration := 0.4

@onready var sprite: Sprite2D = $Sprite
@onready var state_machine: Node = $StateMachine

var was_on_floor: bool
var jumps_remaining := max_jumps

func _ready() -> void:
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	print(velocity)
	was_on_floor = is_on_floor()
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)


#extends CharacterBody2D
#
#@export var speed = 200
#@export var jump_speed = -450
#@export var gravity = 2000
#@export_range(0.0, 1.0) var friction = 0.1
#@export_range(0.0 , 1.0) var acceleration = 0.25
#
#
#func _physics_process(delta):
#	velocity.y += gravity * delta
#	var dir = Input.get_axis("walk_left", "walk_right")
#	if dir != 0:
#		velocity.x = lerp(velocity.x, dir * speed, acceleration)
#	else:
#		velocity.x = lerp(velocity.x, 0.0, friction)
#	
#	if dir != 0:
#		$Sprite2D.flip_h = dir == -1
#
#	move_and_slide()
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#		velocity.y = jump_speed
