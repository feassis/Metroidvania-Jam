extends Area2D
class_name Pickupable

func _on_area_entered(area):
	print("Area:" + str(area.name))
	print("Parent:" + str(area.get_parent().name))
	if area.get_parent() is Player:
		Execution((area.get_parent() as Player))
		self.queue_free()

func Execution(player: Player):
	pass
