extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	for body in $Platforms.get_children():
		var collision_shape: CollisionShape2D = body.get_node("CollisionShape2D")
		if collision_shape.shape is CapsuleShape2D:
			var capsule_shape: CapsuleShape2D = collision_shape.shape
			var texture_poly = Polygon2D.new()
			var h = capsule_shape.height
			var r = capsule_shape.radius
			texture_poly.polygon = PackedVector2Array([
				# right side
				collision_shape.global_position + (Vector2(h/2,-r)).rotated(collision_shape.global_rotation + PI/2),

				collision_shape.global_position + (Vector2(h/2 + r/2,-r/2)).rotated(collision_shape.global_rotation + PI/2),
				collision_shape.global_position + (Vector2(h/2 + r/2,r/2)).rotated(collision_shape.global_rotation + PI/2),

				collision_shape.global_position + (Vector2(h/2,r)).rotated(collision_shape.global_rotation + PI/2),

				# left side
				collision_shape.global_position + (Vector2(-h/2,r)).rotated(collision_shape.global_rotation + PI/2),

				collision_shape.global_position + (Vector2(-h/2 -  r/2,r/2)).rotated(collision_shape.global_rotation + PI/2),
				collision_shape.global_position + (Vector2(-h/2 -  r/2,-r/2)).rotated(collision_shape.global_rotation + PI/2),

				collision_shape.global_position + (Vector2(-h/2,-r)).rotated(collision_shape.global_rotation + PI/2),

			])
			texture_poly.texture = Shared.cavetile4
			texture_poly.texture_scale = Vector2.ONE * 10.0
			texture_poly.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
			add_child(texture_poly)
