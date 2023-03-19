extends CanvasLayer

@onready var pause_menu: Node2D = $PauseMenu
@onready var mute_button: Button = $PauseMenu/MuteButton
@export var playervar: NodePath

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	if AudioServer.is_bus_mute(0):
		mute_button.text = "Sound: Off"
	else:
		mute_button.text = "Sound: On"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("cancel_or_pause"):
		toggle_pause()

func _on_restart_button_pressed():
	get_tree().paused = false
	Main.retry()

func _on_quit_button_pressed():
	get_tree().paused = false
	Main.quit_to_main_menu()


func _on_mute_button_pressed():
	if AudioServer.is_bus_mute(0):
		AudioServer.set_bus_mute(0, false)
		mute_button.text = "Sound: On"
	else:
		AudioServer.set_bus_mute(0, true)
		mute_button.text = "Sound: Off"

func toggle_pause():
	pause_menu.visible = !pause_menu.visible
	get_tree().paused = pause_menu.visible

func set_pause(val: bool):
	pause_menu.visible = val
	get_tree().paused = val
