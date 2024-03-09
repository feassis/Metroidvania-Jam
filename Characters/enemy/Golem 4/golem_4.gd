extends Enemy

@export var damage : int = 1
@export var atkCooldown : float = 2
var atkTimer:float = 0

@onready var UpDetection : Golem4AttackDetection = $"UP"
@onready var DownDetection : Golem4AttackDetection = $"Down"
@onready var RightDetection : Golem4AttackDetection = $"Right"
@onready var LeftDetection : Golem4AttackDetection = $"Left"

var isAttacking: bool

func _process(delta):
	if atkTimer > 0:
		atkTimer -= delta
	
	if isAttacking:
		return
	
	super(delta)
 
func onContactTarget():
	if atkTimer > 0:
		return
	
	isAttacking = true
	atkTimer = atkCooldown
	match currentMovement:
		MoveDir.Up:
			animationManager.play("attack up")
		MoveDir.Down:
			animationManager.play("attack down")
		MoveDir.Left:
			animationManager.play("attack left")
		MoveDir.Right:
			animationManager.play("attack right")
	


func _on_animated_sprite_2d_animation_finished():
	var animName = animationManager.get_animation()
	
	isAttacking = false
	match animName:
		"attack up":
			UpDetection.Attack(damage)
		"attack down":
			DownDetection.Attack(damage)
		"attack left":
			LeftDetection.Attack(damage)
		"attack right":
			RightDetection.Attack(damage)
		"damage right":
			isRecievingDamage = false
		"damage left":
			isRecievingDamage = false
		"damage up":
			isRecievingDamage = false
		"damage down":
			isRecievingDamage = false
