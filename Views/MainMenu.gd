extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Main.progress_index = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mute_audio_button_pressed():
	AudioServer.set_bus_mute(0, true)


func _on_start_game_button_pressed():
	Main.progress_to_next()
