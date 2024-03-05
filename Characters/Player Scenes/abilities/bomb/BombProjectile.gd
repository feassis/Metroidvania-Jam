extends BaseProjectile


@export_category('Bomb Bounce')
@export var bounce_curve : Curve
@export var max_height : float = 40.0
@export var max_collision_height = 20.0

@onready var sprite_2d = $Sprite2D
@onready var drop_shadow = $DropShadow
@onready var explosion_timer = $ExplosionTimer
@onready var collision_shape_2d = $CollisionShape2D

const FRICTION = 1000
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var height_ratio = bounce_curve.sample((explosion_timer.wait_time - explosion_timer.time_left) / explosion_timer.wait_time)
	var target_height = max(max_height * height_ratio, 0.0)
	_set_height(target_height)
	monitoring = _current_bomb_height() < max_collision_height
	super(delta)
	
	if _current_bomb_height() < 0.1:
		speed = max(speed - FRICTION * delta, 0.0)
	
	_process_drop_shadow()

func _process_drop_shadow():
	drop_shadow.frame_coords.x = floor(drop_shadow.hframes * (_current_bomb_height() / max_height))
	
func _on_body_entered(body):
	if body is Player:
		return
	
	explode()

func explode():
	queue_free()

func _set_height(new_height):
	sprite_2d.position.y = new_height * -1.0
	collision_shape_2d.position.y = new_height * -1.0

func _current_bomb_height() -> float:
	return -sprite_2d.position.y
	
func _on_timer_timeout():
	explode()

func _on_max_range_reached():
	pass
