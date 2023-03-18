extends Area2D

@export var damage: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Player:
		if body.apply_damage(damage):
			body.apply_central_impulse(global_position.direction_to(body.global_position) * 550.0)
