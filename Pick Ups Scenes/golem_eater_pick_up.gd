extends Pickupable

@export var duration: float = 60

func Execution(player: Player):
	player.DevourMode(duration)
