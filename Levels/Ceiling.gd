
extends StaticBody2D

class_name Grabbable

func _ready():
	collision_layer = collision_layer | 0b10

