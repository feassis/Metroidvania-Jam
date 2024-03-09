extends BaseProjectile

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _collided():
	speed = 0.0
	monitoring = false
	animation_player.play('hit')

func _on_body_entered(body):
	_collided()
	
func _on_hitbox_entered(entity: Node2D):
	if entity is Enemy:
		# TODO: damage entity
		pass
	_collided()

func _on_animation_finished(animation_name: String):
	if animation_name == 'hit':
		queue_free()
	
