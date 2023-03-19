extends Node

var story_text: String = ""

var scenes: Dictionary = {
	"main_menu": load("res://Views/MainMenu.tscn"),
	"hud": load("res://Views/Hud.tscn"),
	"story": load("res://Views/StoryScreen.tscn"),
	"boring": load("res://Levels/Level1.tscn"),
	"intro1": load("res://Levels/Level2.tscn"),
	"caves1": load("res://Levels/Level3.tscn"),
	"building": load("res://Levels/Level4.tscn"),
	"maze1": load("res://Levels/Level5.tscn"),
}

var stories: Dictionary = {
	"intro": "You are The Sandman. You can use your sand powers to travel around and put foes to sleep. 
 
	
	Hint: Press Space Bar to propel your player towards your curser. A linear indicator appears when one of your hands can attach to a surface",
	"level2": "I don't like sand. It's coarse and rough and irritating and it gets everywhere. Not like here. Here everything is soft and smooth.
	
	Hint: Each of your hands can grapple to a surface independently. Make sure to alternate hands to optimize movement. Right click to put enemies to sleep",
	"level3": "Is this the right Sandman? Seems more like the Marvel one...
	
	Hint: Use Space Bar to gain enough speed to break through glass panes. You can walk into switches to flip them.",
	"level4": "Your final Sand challenge awaits...",
	"ending": "At last your Sand journey is complete. And it is you now who gets to sleep.",
}

# sequencer for how the game progresses. call Main.progress_to_next() from anywhere to continue the game or Main.retry() to retry a level
# You can change music, set variables, do whatever before calling change_scene_to_packed to switch the scene
# return true to run one time setup and automatically go to the next function
# example for transition:
## func(): transition_text = "Our hero lives to see another day..."; get_tree().change_scene_to_packed(scenes.transition),
var progress_index: int = -1
var progression_arr: Array = [
	func(): Music.set_track("menu"); return true,
	func(): get_tree().change_scene_to_packed(scenes.main_menu),
	func(): get_tree().change_scene_to_packed(scenes.hud); return true,
	func(): story_text = stories.intro; return true,
	func(): Music.set_track("level1"); return true,
	func(): get_tree().change_scene_to_packed(scenes.story),
	func(): get_tree().change_scene_to_packed(scenes.intro1),
	func(): story_text = stories.level2; return true,
	func(): Music.set_track("level2"); return true,
	func(): get_tree().change_scene_to_packed(scenes.story),
	func(): get_tree().change_scene_to_packed(scenes.caves1),
	func(): story_text = stories.level3; return true,
	func(): Music.set_track("level3"); return true,
	func(): get_tree().change_scene_to_packed(scenes.story),
	func(): get_tree().change_scene_to_packed(scenes.building),
	func(): story_text = stories.level4; return true,
	func(): Music.set_track("level4"); return true,
	func(): get_tree().change_scene_to_packed(scenes.story),
	func(): get_tree().change_scene_to_packed(scenes.maze1),
	func(): story_text = stories.ending; return true,
	func(): Music.set_track("menu"); return true,
	func(): get_tree().change_scene_to_packed(scenes.story),
]

func quit_to_main_menu():
	progress_index = -1
	progress_to_next()

func retry():
	progression_arr[progress_index].call()

func progress_to_next():
	increment_progress()
	while progression_arr[progress_index].call(): increment_progress()

func increment_progress():
	progress_index = (progress_index + 1) % len(progression_arr)

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_to_next()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
