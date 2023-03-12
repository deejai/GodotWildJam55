extends RigidBody2D

var segments: float = 60.0
var amplitude: float = 30.0
var period: float = 15.0

var time_elapsed: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	wiggle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	wiggle()

func wiggle():
	for i len
