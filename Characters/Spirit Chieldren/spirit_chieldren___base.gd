extends Area2D
class_name SpiritChieldrenBase

@export var animManager : AnimatedSprite2D
@export var idleDuration: float =  5
@export var skill : Player.Skill = Player.Skill.NormalAttack
var moveDir : MoveDir = MoveDir.Down
var idleTimer : float = 0

func _ready():
	idleTimer = idleDuration
	Animate()

func _process(delta):
	if idleTimer > 0:
		idleTimer -= delta
	else:
		ChangeIdleState()
	

func Animate():
	match moveDir:
		MoveDir.Down:
			animManager.play("idle down")
		MoveDir.Up:
			animManager.play("idle up")
		MoveDir.Left:
			animManager.play("idle left")
		MoveDir.Right:
			animManager.play("idle right")
	

func ChangeIdleState():
	var randNum: int = randi() % (4)
	idleTimer = idleDuration
	match randNum:
		0:
			moveDir = MoveDir.Down
		1: 
			moveDir = MoveDir.Up
		2:
			moveDir = MoveDir.Left
		3:
			moveDir = MoveDir.Right
	
	Animate()

enum MoveDir {Left, Right, Up, Down}

func GetDevoured(player : Player):
	player.UnlockSkill(skill)
	self.queue_free()

	
