extends Node2D

func _ready():
	print(name + transform.basis_xform(Vector2.forward))
