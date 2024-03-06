extends Enemy

@export var damage : int = 1
@export var atkCooldown : float = 1.5
var atkTimer:float = 0

func _process(delta):
	if atkTimer > 0:
		atkTimer -= delta
	
	super(delta)
 
func onContactTarget():
	if atkTimer > 0:
		return
	
	target.health.TakeDamage(damage)
	atkTimer = atkCooldown
