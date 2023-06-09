extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mute_audio_button_pressed():
	if AudioServer.is_bus_mute(0):
		AudioServer.set_bus_mute(0, false)
		$MuteAudioButton.text = "Sound: On"
	else:
		AudioServer.set_bus_mute(0, true)
		$MuteAudioButton.text = "Sound: Off"

func _on_start_game_button_pressed():
	Main.progress_to_next()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_how_to_play_button_pressed():
	add_child(load("res://Views/HowTo.tscn").instantiate())
