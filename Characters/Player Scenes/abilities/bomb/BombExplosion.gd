extends Area2D


@onready var hitbox_hit : Array[HitBox] = []

func _on_area_entered(area):
	if area is HitBox && !hitbox_hit.has(area):
		hitbox_hit.append(area)
		#TODO: deal damage

func _on_animated_sprite_2d_animation_finished():
	queue_free()
