extends StaticBody2D

func _ready():
	collision_layer = collision_layer | 0b10

func _draw():
	draw_rect(Rect2(Vector2.ZERO - $CollisionShape2D.shape.size/2, $CollisionShape2D.shape.size), Color.DARK_OLIVE_GREEN)

