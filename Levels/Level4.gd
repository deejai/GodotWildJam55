extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$ZoneHider/ColorRect/AnimationPlayer.play_backwards("fade_out")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_building_zone_body_entered(body):
	if body is Player:
		$ZoneHider/ColorRect/AnimationPlayer.play("fade_out")
		print("TEST!")



func _on_building_zone_body_exited(body):
	if body is Player:
		$ZoneHider/ColorRect/AnimationPlayer.play_backwards("fade_out")
