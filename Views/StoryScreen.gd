extends CanvasLayer

func storyText(text):
	$TextBox.text = text

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextBox.text = Main.story_text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(str("story", delta))

func _input(event:InputEvent):
	if event is InputEventMouseButton:
		$GoNextTimer.start()

func _on_go_next_timer_timeout():
	Main.progress_to_next()
