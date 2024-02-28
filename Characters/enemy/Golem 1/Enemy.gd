extends CharacterBody2D
class_name Enemy

@export var agent: NavigationAgent2D
@export var speed: float = 50
@export var avoidanceRange: float = 15
@export var animationManager: AnimatedSprite2D;

var target: Player = null
var hasTouchedPlayer:bool = false
var wasDevoured: bool = false
var currentMovement: MoveDir
var stunTimer: float  

var knockbackDirection: Vector2
var knockbackTimer: float
var knockbackSpeed: float

func Knockback(dir: Vector2, speed: float, duration: float):
	if knockbackTimer > 0:
		return
	knockbackDirection = dir
	knockbackTimer = duration
	knockbackSpeed = speed

func _process(delta):
	if stunTimer > 0:
		stunTimer -= delta
		
	if stunTimer > 0:
		stunTimer -= delta
	
	if knockbackTimer > 0:
		knockbackTimer -= delta
		
		if knockbackTimer <=0:
			velocity = Vector2(0 , 0)
		else:
			velocity = knockbackDirection * knockbackSpeed
		
		move_and_slide()
		return
	
	if stunTimer > 0:
		return
	
	animateWalk(velocity)
	if wasDevoured:
		return
	
	if target == null:
		velocity = Vector2(0,0)
		return
	
	agent.set_target_position(target.position)
	
	var distanceToTarget = position.distance_to(target.position)
	
	if  distanceToTarget < avoidanceRange:
		onContactTarget()
		return
		
	var curLoc = global_transform.origin
	var nextLoc = agent.get_next_path_position()
	var newVel = (nextLoc - curLoc).normalized() * speed
	velocity = newVel
	setMovementDirection(velocity)

	move_and_slide()

func animateWalk(vel: Vector2):
	if vel == Vector2(0, 0):
		match currentMovement:
			MoveDir.Up:
				animationManager.play("idle up")
			MoveDir.Down:
				animationManager.play("idle down")
			MoveDir.Left:
				animationManager.play("idle left")
			MoveDir.Right:
				animationManager.play("idle right")
	else:
		match currentMovement:
			MoveDir.Up:
				animationManager.play("walk up")
			MoveDir.Down:
				animationManager.play("walk down")
			MoveDir.Left:
				animationManager.play("walk left")
			MoveDir.Right:
				animationManager.play("walk right")

func setMovementDirection(vel: Vector2):
	if vel.y < 0:
		if abs(vel.y) >= abs(vel.x):
			currentMovement = MoveDir.Up
		elif vel.x >= 0:
			currentMovement = MoveDir.Right
		else:
			currentMovement = MoveDir.Left
	else:
		if abs(vel.y) >= abs(vel.x):
			currentMovement = MoveDir.Down
		elif vel.x >= 0:
			currentMovement = MoveDir.Right
		else:
			currentMovement = MoveDir.Left

func onContactTarget():
	if target.currentLife <= 0:
		return
	
	hasTouchedPlayer = target.Kill()


func GetDevoured():
	wasDevoured = true
	self.queue_free()

func Stun(duration):
	stunTimer = duration
	



func _on_detection_area_body_entered(body):
	if body is Player:
		target = (body as Player)

func _on_detection_area_body_exited(body):
	if body == target:
		target = null

func GetFacingVector() -> Vector2:
	match currentMovement:
		MoveDir.Up:
			return Vector2(0, -1)
		MoveDir.Down:
			return Vector2(0, 1)
		MoveDir.Left:
			return Vector2(-1, 0)
		MoveDir.Right:
			return Vector2(1, 0)
	return Vector2(0,0)


enum MoveDir {Left, Right, Up, Down}
