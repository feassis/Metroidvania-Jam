extends BaseAbility

const PULSE_CONTROLER = preload("res://Characters/Player Scenes/abilities/pulse/pulse_controler.tscn")

@export var knockbackSpeed : float
@export var knockbackDuration : float
@export var stunDuration : float

func _ability(player : Player):
	var pulseInstance : PulseWave = PULSE_CONTROLER.instantiate() as PulseWave
	pulseInstance.stunDuration = stunDuration
	pulseInstance.knockbackSpeed = knockbackSpeed
	pulseInstance.knockbackDuration = knockbackDuration
	pulseInstance.position = player.position
	get_tree().get_root().add_child(pulseInstance)
