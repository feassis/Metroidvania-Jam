extends Pickupable

@export var healAmount: int = 1

func Execution(player: Player):
	player.health.Heal(healAmount)
