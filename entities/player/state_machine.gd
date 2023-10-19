class_name StateMachine
extends Node

@export var starting_state: State

var current_state: State
var prev_state: State

var stateHistory := ["", "", "", "", "", "", ""]
var currentIndex := 0


# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default starting_state.
func init(parent: Player) -> void:
	for child in get_children():
		child.parent = parent

	# Initialize to the default state
	change_state(starting_state)

# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	if prev_state != new_state:
		prev_state = new_state
	current_state = new_state
	current_state.enter()
	
# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	%Label.global_position = Vector2(0,0)
	if currentIndex + 1 < 7:
		currentIndex += 1
	else:
		currentIndex = 0
	
	stateHistory[currentIndex] = current_state.name
	var txt = ""
	for state in stateHistory:
		txt += state + "\n"
	%Label.text = txt
		
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
