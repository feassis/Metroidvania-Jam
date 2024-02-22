extends Area2D
class_name Pickupable

func _on_area_entered(area):
	if area.get_parent() is Player:
		Execution((area.get_parent() as Player))

func Execution(player: Player):
	pass
