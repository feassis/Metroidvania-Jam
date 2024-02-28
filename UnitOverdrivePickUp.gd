extends Pickupable

@export var maxHPIncrement: int = 1

func Execution(player: Player):
	player.health.IncreaseMaxHP(maxHPIncrement)
	player.health.Heal(maxHPIncrement)
