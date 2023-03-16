extends Node


var story_text: String = ""

var scenes: Dictionary = {
	"main_menu": preload("res://Views/MainMenu.tscn"),
	"story": preload("res://Views/StoryScreen.tscn"),
	"boring": preload("res://Levels/Level1.tscn"),
	"intro1": preload("res://Levels/Level2.tscn"),
	"caves1": preload("res://Levels/Level3.tscn"),
	"caves1_zoomed": preload("res://Levels/Level33.tscn"),
	"wip": preload("res://Levels/Level4.tscn"),
}

# sequencer for how the game progresses. call Main.progress_to_next() from anywhere to continue the game or Main.retry() to retry a level
# You can change music, set variables, do whatever before calling change_scene_to_packed to switch the scene
# return true to run one time setup and automatically go to the next function
# example for transition:
## func(): transition_text = "Our hero lives to see another day..."; get_tree().change_scene_to_packed(scenes.transition),
var progression_arr: Array = [
	func(): get_tree().change_scene_to_packed(scenes.main_menu),
	func(): get_tree().change_scene_to_packed(scenes.intro1),
	func(): story_text ="Good Job!"; return true,
	func(): get_tree().change_scene_to_packed(scenes.story),
	func(): get_tree().change_scene_to_packed(scenes.caves1_zoomed),
	func(): story_text ="Well Done!"; return true,
	func(): get_tree().change_scene_to_packed(scenes.story),
	func(): get_tree().change_scene_to_packed(scenes.wip)
]

var progress_index: int = 0

func retry():
	progression_arr[progress_index].call()

func progress_to_next():
	increment_progress()
	while progression_arr[progress_index].call(): increment_progress()

func increment_progress():
	progress_index = (progress_index + 1) % len(progression_arr)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
