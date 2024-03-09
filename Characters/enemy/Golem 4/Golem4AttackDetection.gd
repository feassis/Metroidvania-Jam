extends Area2D
class_name Golem4AttackDetection

var player:Player = null


func Attack(dmg:int):
	if player == null:
		return
	player.health.TakeDamage(dmg)


func _on_body_entered(body):
	if body is Player:
		player = (body as Player)
		


func _on_body_exited(body):
	if body is Player:
		player = null
