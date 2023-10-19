class_name Player
extends CharacterBody2D

@export_category("Movement")
@export_subgroup("Misc")
@export var speed := 200
@export_range(0.0, 1.0) var friction := 0.3
@export_range(0.0, 1.0) var air_friction := 0.1
@export_range(0.0 , 1.0) var acceleration := 0.4
@export_subgroup("Jump")
@export var jump_height: float = 100
@export var jump_time_to_peak: float = .5
@export var jump_time_to_descent: float = .4
@export var jump_variable_height: float = 25
@export var wall_jump_pushback := -225
@export var wall_slide_gravity := 100
@export var max_jumps := 1

@onready var sprite: Sprite2D = $Sprite
@onready var state_machine: Node = $StateMachine
@onready var animator: AnimationPlayer = $AnimationPlayer

@onready var jump_velocity := ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity := ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity := ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var variable_gravity := (jump_velocity * jump_velocity) / (2 * jump_variable_height)

var jumps_remaining := max_jumps

func _ready() -> void:
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func get_gravity() -> float:
	if not Input.is_action_pressed("jump") and velocity.y < 0.0:
		return variable_gravity
	return jump_gravity if velocity.y < 0.0 else fall_gravity
