extends Pickupable

@export var lifeGainAmount: int = 1

func Execution(player: Player):
	player.GainLife(lifeGainAmount)
