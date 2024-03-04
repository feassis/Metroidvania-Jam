extends BaseAbility
class_name ResetAbility

func _ability(player : Player):
	player.global_position = player.respawnPoint.global_position
