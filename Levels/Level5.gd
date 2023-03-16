extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$MazeHider/AnimationPlayer.play_backwards("fade_out")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_maze_zone_body_entered(body):
	if body is Player:
		$MazeHider/AnimationPlayer.play("fade_out")


func _on_maze_zone_body_exited(body):
	if body is Player:
		$MazeHider/AnimationPlayer.play_backwards("fade_out")


func _on_finish_line_body_entered(body):
	if body is Player:
		var transition = preload("res://Menus/Transition.tscn")
		var instance = transition.instantiate()
		add_child(instance)
