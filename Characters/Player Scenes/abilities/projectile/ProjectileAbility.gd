extends BaseAbility

const PLAYER_PROJECTILE = preload("res://Characters/Player Scenes/abilities/projectile/player_projectile.tscn")

func _ability(player : Player):
	var projectile = PLAYER_PROJECTILE.instantiate()
	projectile.global_position = player.global_position
	# TODO get mouse position instead of facing vector
	projectile.direction = player.GetFacingVector()
	projectile.look_at(projectile.global_position + player.GetFacingVector())
	get_tree().root.add_child(projectile)
