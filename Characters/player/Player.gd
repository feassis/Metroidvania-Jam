extends CharacterBody2D
class_name Player

@export var speed:float = 300.0
@export var animManager : AnimatedSprite2D
@export var initialMaxHP: int = 5
@export var health: Health

var currentMovement: MoveDir= MoveDir.Down

func _ready():
	PlayAnimMove(Vector2(0,0))

func _physics_process(delta):
	PlayerMovement(delta)
	
	
func SubscribeHealthUI(ui : HealthUI):
	health.SubscribeUI(ui)

func PlayerMovement(delta: float):
	var direction = HandleMovementDirection()
	
	ControlCurrentMoveDirection(direction)
		
	velocity = direction.normalized() * speed
	
	move_and_slide()
	PlayAnimMove(direction)

func PlayAnimMove(direction: Vector2):
	if direction == Vector2(0,0):
		match currentMovement:
			MoveDir.Up:
				animManager.play("back walk")
			MoveDir.Down:
				animManager.play("front walk")
			MoveDir.Left:
				animManager.play("left walk")
			MoveDir.Right:
				animManager.play("right walk")
	else:
		match currentMovement:
			MoveDir.Up:
				animManager.play("back idle")
			MoveDir.Down:
				animManager.play("front idle")
			MoveDir.Left:
				animManager.play("left idle")
			MoveDir.Right:
				animManager.play("right idle")

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
