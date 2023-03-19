extends Node

var player: AudioStreamPlayer = AudioStreamPlayer.new()

var track_dict: Dictionary = {
	"menu": load("res://Assets/Music/Menu.mp3"),
	"level1": load("res://Assets/Music/1stLevel.mp3"),
	"level2": load("res://Assets/Music/2ndLevel.mp3"),
	"level3": load("res://Assets/Music/3rdLevel.mp3"),
	"level4": load("res://Assets/Music/LastLevel.mp3"),
}

var current_track: String = ""

var initialized: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_track(name: String):
	if not initialized:
		player.volume_db = -6
		add_child(player)
		initialized = true

	if not track_dict.has(name):
		printerr(str("Could not find track: ", name))

	if name == current_track:
		return

	player.stream = track_dict[name]
	player.play()

func stop():
	player.stop()
