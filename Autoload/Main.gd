extends Node

var story_text: String = ""

var scenes: Dictionary = {
	"main_menu": preload("res://Views/MainMenu.tscn"),
	"hud": preload("res://Views/Hud.tscn"),
	"story": preload("res://Views/StoryScreen.tscn"),
	"boring": preload("res://Levels/Level1.tscn"),
	"intro1": preload("res://Levels/Level2.tscn"),
	"caves1": preload("res://Levels/Level3.tscn"),
	"caves1_zoomed": preload("res://Levels/Level33.tscn"),
	"building": preload("res://Levels/Level4.tscn"),
	"maze1": preload("res://Levels/Level5.tscn"),
}

var stories: Dictionary = {
	"intro": "As you swing through your hometown, memories blend with dreams, warping reality into something surreal. Keep your focus sharp; you could lose yourself in this strange new world.",
	"level2": "The deep shadows of the cave seem to stretch on forever, teasing your subconscious half-formed visions. Your own half-conscious mind threatens to consume you.",
	"level3": "You feel a sense of deja vu wash over you. It's as if you've been here before, in another life, in another dream. But there's no time for contemplation - you'll need to act fast to overcome.",
	"level4": "LEVEL 4 TEXT",
	"ending": "YOU WIN!!!!",
}

# sequencer for how the game progresses. call Main.progress_to_next() from anywhere to continue the game or Main.retry() to retry a level
# You can change music, set variables, do whatever before calling change_scene_to_packed to switch the scene
# return true to run one time setup and automatically go to the next function
# example for transition:
## func(): transition_text = "Our hero lives to see another day..."; get_tree().change_scene_to_packed(scenes.transition),
var progress_index: int = 0
var progression_arr: Array = [
	func(): get_tree().change_scene_to_packed(scenes.main_menu),
	func(): get_tree().change_scene_to_packed(scenes.hud); return true,
	func(): story_text = stories.intro; return true,
	func(): get_tree().change_scene_to_packed(scenes.story),
	func(): get_tree().change_scene_to_packed(scenes.intro1),
	func(): story_text = stories.level2; return true,
	func(): get_tree().change_scene_to_packed(scenes.story),
	func(): get_tree().change_scene_to_packed(scenes.caves1_zoomed),
	func(): story_text = stories.level3; return true,
	func(): get_tree().change_scene_to_packed(scenes.story),
	func(): get_tree().change_scene_to_packed(scenes.building),
	func(): story_text = stories.level4; return true,
	func(): get_tree().change_scene_to_packed(scenes.story),
	func(): get_tree().change_scene_to_packed(scenes.maze1),
	func(): story_text = stories.ending; return true,
	func(): get_tree().change_scene_to_packed(scenes.story),
]

func quit_to_main_menu():
	get_tree().change_scene_to_packed(scenes.main_menu)
	progress_index = 0

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
