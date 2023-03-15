extends CanvasLayer
var nextlevel = preload("res://Levels/Level4.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	$TransitionRectangle/AnimationPlayer.play("fade_to_black")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	await get_tree().create_timer(1.0).timeout
	Main.progress_to_next()
