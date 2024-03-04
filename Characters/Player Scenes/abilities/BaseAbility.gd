extends Node
class_name BaseAbility

@export_category('Ability')
@export var icon : Texture2D
@export var ability_name : String = ''
@export var cooldown = 2.0

var cooldownTimer : float = 0.0

func _process(delta : float):
	cooldownTimer -= delta
	
func use(player : Player):
	if cooldownTimer <= 0.0:
		cooldownTimer = cooldown
		_ability(player)

func _ability(player : Player):
	pass
