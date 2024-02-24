extends CharacterBody2D
class_name Player

@export var speed:float = 100.0
@export var sprintSpeed:float = 300.0
@export var dashVelocity: float = 500.0
@export var animManager : AnimatedSprite2D
@export var initialMaxHP: int = 5
@export var health: Health
@export var devourFrameDelay: int = 8
@export var timer : Timer

@export var UpDetection : DevourDetection
@export var DownDetection : DevourDetection
@export var RightDetection : DevourDetection
@export var LeftDetection : DevourDetection

var isDevouring : bool = false
var isTakingDamage: bool = false

var currentMovement: MoveDir= MoveDir.Down

func _ready():
	PlayAnimMove(Vector2(0,0))
	
func IsInvulnerable() -> bool:
	return isDevouring || isTakingDamage

func _physics_process(delta):
	if isDevouring || isTakingDamage:
		return
	
	PlayerMovement(delta)
	
	if Input.is_action_just_pressed("devour"):
		DevourAction(delta)
	
func SubscribeHealthUI(ui : HealthUI):
	health.SubscribeUI(ui)

func GetSpeed() -> float:
	if Input.is_action_just_pressed("sprint"):
		return sprintSpeed
	return speed

func PlayerMovement(delta: float):
	var direction = HandleMovementDirection()
	
	ControlCurrentMoveDirection(direction)
		
	velocity = direction.normalized() * GetSpeed()
	
	move_and_slide()
	PlayAnimMove(direction)
	
func DevourAction(delta):
	isDevouring = true
	PlayAnimDevour()
	
func Kill() -> bool:
	if IsInvulnerable():
		return false
	health.Kill()
	return true

func PlayDamageAnim():
	isTakingDamage = true
	match currentMovement:
		MoveDir.Up:
			animManager.play("damage up")
		MoveDir.Down:
			animManager.play("damage down")
		MoveDir.Left:
			animManager.play("damage left")
		MoveDir.Right:
			animManager.play("damage right")

func Devour():
	print("Devour")
	match currentMovement:
		MoveDir.Up:
			UpDetection.Devour()
		MoveDir.Down:
			DownDetection.Devour()
		MoveDir.Left:
			LeftDetection.Devour()
		MoveDir.Right:
			RightDetection.Devour()
			
	isDevouring = false
	

func PlayAnimDevour():
	match currentMovement:
		MoveDir.Up:
			animManager.play("devour back")
		MoveDir.Down:
			animManager.play("devour front")
		MoveDir.Left:
			animManager.play("devour left")
		MoveDir.Right:
			animManager.play("devour right")
	

func PlayAnimMove(direction: Vector2):
	if direction == Vector2(0,0):
		match currentMovement:
			MoveDir.Up:
				animManager.play("back idle")
			MoveDir.Down:
				animManager.play("front idle")
			MoveDir.Left:
				animManager.play("left idle")
			MoveDir.Right:
				animManager.play("right idle")
	else:
		match currentMovement:
			MoveDir.Up:
				animManager.play("back walk")
			MoveDir.Down:
				animManager.play("front walk")
			MoveDir.Left:
				animManager.play("left walk")
			MoveDir.Right:
				animManager.play("right walk")

func HandleMovementDirection() -> Vector2:
	var direction = Vector2(0,0)
	
	if Input.is_action_pressed('move up'):
		direction.y -= 1
	
	if Input.is_action_pressed('move down'):
		direction.y += 1
		
	if Input.is_action_pressed('move left'):
		direction.x -= 1
		
	if Input.is_action_pressed('move right'):
		direction.x += 1
	
	return direction

func ControlCurrentMoveDirection(direction: Vector2):
	if direction.y < 0:
		currentMovement = MoveDir.Up
	elif direction.y > 0:
		currentMovement = MoveDir.Down
	elif direction.x < 0:
		currentMovement = MoveDir.Left
	elif direction.x > 0:
		currentMovement = MoveDir.Right
	

enum MoveDir {Left, Right, Up, Down}

func _on_animated_sprite_2d_animation_finished():
	var animName = animManager.get_animation()
	
	match animName:
		"devour back":
			Devour()
		"devour front":
			Devour()
		"devour right":
			Devour()
		"devour left":
			Devour()
		"damage up":
			isTakingDamage = false
		"damage down":
			isTakingDamage = false
		"damage left":
			isTakingDamage = false
		"damage right":
			isTakingDamage = false
