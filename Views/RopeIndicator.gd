extends Control
var Lgrabbing: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$Ropeno.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Lgrabbing = Player.L_is_grabbing()
	if Lgrabbing:
		$Rope.hide()
		$Ropeno.show()
