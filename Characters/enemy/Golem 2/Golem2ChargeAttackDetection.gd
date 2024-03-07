extends Area2D
class_name Golem2AttackDetection

var player:Player = null

var isAttacking : bool = false
var hasAttack: bool = false

func _process(delta):
	if isAttacking && !hasAttack:
		ChargeAttack()

func ChargeAttack():
	if player == null:
		return
	
	hasAttack = true
	player.HalfLife()


func _on_body_entered(body):
	if body is Player:
		player = (body as Player)
		


func _on_body_exited(body):
	if body is Player:
		player = null
