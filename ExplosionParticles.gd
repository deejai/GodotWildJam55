extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if emitting == false:
		queue_free()
