extends Node2D
@onready var ropeL = $RopeL
@onready var ropeR = $RopeR
var grabbingL: bool = false
var grabbingR: bool = false
@export var ropeno: Texture2D
@export var ropeyes: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	ropeL.texture = ropeno
	ropeR.texture = ropeno


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	grabbingR = get_parent().get_parent().get_parent().grabbing_R 
	grabbingL = get_parent().get_parent().get_parent().grabbing_L

	if grabbingL:
		ropeL.texture = ropeno
	else:
		ropeL.texture = ropeyes
	if grabbingR:
		ropeR.texture = ropeno
	else:
		ropeR.texture = ropeyes
	
	


	
	
	
