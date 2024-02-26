extends Area2D
class_name Golem2AttackDetection

var player:Player = null



func ChargeAttack():
	if player == null:
		return
	
	player.HalfLife()


func _on_body_entered(body):
	if body is Player:
		player = (body as Player)


func _on_body_exited(body):
	if body is Player:
		player = null
