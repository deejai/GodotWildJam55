extends Node2D

#func _Message

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.dd   d 
func _process(delta):
	pass


func _on_finish_line_body_entered(body):
	var transition = preload("res://Menus/Transition.tscn")
	var instance = transition.instantiate()
	add_child(instance)
	print("hello world")
