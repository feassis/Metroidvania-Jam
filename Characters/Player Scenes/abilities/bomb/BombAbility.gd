extends BaseAbility

const BOMB_PROJECTILE = preload("res://Characters/Player Scenes/abilities/bomb/bomb_projectile.tscn")

func _ability(player : Player):
	var projectile = BOMB_PROJECTILE.instantiate()
	projectile.global_position = player.global_position
	projectile.direction = player.GetFacingVector()
	Helper.add_to_world(projectile)
