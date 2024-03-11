extends Area2D
class_name BaseProjectile

@export var speed : float = 50.0
@export var max_range : float = 500.0
@export var spawn_distance_offset = 5.0
@export var isPlayerProjectile: bool = true
var direction : Vector2 = Vector2.RIGHT
var damage:int = 1

var distance_travelled = 0.0

func _process(delta : float):
	var dist : float = speed * delta
	distance_travelled += dist
	position += direction * dist
	if max_range < distance_travelled:
		_on_max_range_reached()

func _on_max_range_reached():
	queue_free()
	
func _on_body_entered(body):
	if isPlayerProjectile:
		if body is Enemy:
			(body as Enemy).GetHitedByProjectile(damage)
	else:
		if body is Player:
			(body as Player).health.TakeDamage(damage)
