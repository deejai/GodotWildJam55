extends CollisionPolygon2D

var texture_poly: Polygon2D = Polygon2D.new()
@export var cavetile: Texture2D = Shared.cavetile1

func _ready():
	texture_poly.polygon = polygon
	texture_poly.texture = cavetile
	texture_poly.texture_scale = Vector2.ONE * 10.0
	texture_poly.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	add_child(texture_poly)

func _draw():
	pass
