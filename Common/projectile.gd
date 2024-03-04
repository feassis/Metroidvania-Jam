extends Area2D
class_name BaseProjectile

@export var speed : float = 50.0
@export var max_range : float = 500.0
@export var spawn_distance_offset = 5.0

var direction : Vector2 = Vector2.RIGHT

var distance_travelled = 0.0

func _process(delta : float):
	var dist : float = speed * delta
	distance_travelled += dist
	position += direction * dist
	if max_range < distance_travelled:
		queue_free()
	
