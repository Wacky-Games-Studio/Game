extends Control

signal just_hidden()

@export var audio_bus_name := "Master"
@export var volume_min: float = -97
@onready var bus := AudioServer.get_bus_index(audio_bus_name)
@onready var vol_slider: HSlider = %VolSlider;
@onready var full_screen: OptionButton = %FullscreenMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	if ResourceLoader.exists("user://settings.dat") == false:
		vol_slider.value = AudioServer.get_bus_volume_db(bus) + volume_min
		return

	var settings_file = FileAccess.open("user://settings.dat", FileAccess.READ)
	var parsed = JSON.parse_string(settings_file.get_as_text())

	if parsed == null or parsed.get("fullscreen") == null or parsed.get("volume") == null:
		vol_slider.value = AudioServer.get_bus_volume_db(bus) + volume_min
		DirAccess.remove_absolute("user://settings.dat")
		return

	var fullscreen_index := int(parsed.get("fullscreen"))
	var volume := float(parsed.get("volume"))

	DisplayServer.window_set_mode(fullscreen_index)

	AudioServer.set_bus_volume_db(bus, volume)
	vol_slider.value = AudioServer.get_bus_volume_db(bus) - volume_min
	full_screen.selected = 0 if fullscreen_index == DisplayServer.WINDOW_MODE_FULLSCREEN else 1
	

func _on_fullscren_item_selected(index:int):
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_volume_slider_value_changed(value:float):
	AudioServer.set_bus_volume_db(bus, value + volume_min)



func _on_reset_progress_pressed():
	DirAccess.remove_absolute("user://savegame.save")

func _on_back_button_pressed():
	var settings_file = FileAccess.open("user://settings.dat", FileAccess.WRITE)
	if settings_file == null:
		print("Couldnt open file!")

	print(AudioServer.get_bus_volume_db(bus))
	var save = {
		volume = AudioServer.get_bus_volume_db(bus),
		fullscreen = DisplayServer.window_get_mode()
	};

	settings_file.store_string(JSON.stringify(save))
	settings_file.close()

	get_parent().hide()


func _on_canvas_layer_visibility_changed():
	if get_parent().visible:
		full_screen.grab_focus()
	else:
		just_hidden.emit()
