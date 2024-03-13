extends Enemy

@export var avoidanceDistance: float = 100
@export var stopDistance:float =  5
@export var attackCooldown: float = 2
@export var enemyProjectile: PackedScene
var attackTimer: float = 0
var isAttacking : bool = false


func _process(delta):
	if attackTimer > 0:
		attackTimer -= delta
	
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
	
	if !isAttacking:
		animateWalk(velocity)
	else:
		return

	if wasDevoured:
		return
	
	if target == null:
		velocity = Vector2(0,0)
		return
		
	Attack()
	SetDirection()
		
	var curLoc = global_transform.origin
	var nextLoc = agent.get_next_path_position()
	
	if curLoc.distance_to(nextLoc) < stopDistance:
		velocity = Vector2(0,0)
		return
	
	var newVel = (nextLoc - curLoc).normalized() * speed
	velocity = newVel

	move_and_slide()

func GetDevoured(damage : int):
	health.TakeDamage(damage)
	
func Attack():
	if attackTimer > 0: 
		return
	
	isAttacking = true
	
	PlayAttackAnimation()
	
func PlayAttackAnimation():
	match currentMovement:
		MoveDir.Up:
			animationManager.play("attack up")
		MoveDir.Down:
			animationManager.play("attack down")
		MoveDir.Left:
			animationManager.play("attack left")
		MoveDir.Right:
			animationManager.play("attack right")
	
func GetBombed(damage: int):
	health.TakeDamage(damage)
	
func GetHitedByProjectile(damage:int):
	health.TakeDamage(damage)

func SetDirection():
	if target.IsOnDevourMode():
		agent.set_target_position(
			(target.position - position)*-1 + position)
		return
		
	var directionToPlayer: Vector2 = (target.position - position)
	setMovementDirection(directionToPlayer)
	
	match currentMovement:
		MoveDir.Up:
			agent.set_target_position(Vector2(target.position.x, (target.position.y + avoidanceDistance)))
		MoveDir.Down:
			agent.set_target_position(Vector2(target.position.x, (target.position.y - avoidanceDistance)))
		MoveDir.Left:
			agent.set_target_position(Vector2((target.position.x + avoidanceDistance), target.position.y))
		MoveDir.Right:
			agent.set_target_position(Vector2((target.position.x - avoidanceDistance), target.position.y))
	
func setMovementDirection(dir: Vector2):
	if dir.y < 0:
		if abs(dir.y) >= abs(dir.x):
			currentMovement = MoveDir.Up
		elif dir.x >= 0:
			currentMovement = MoveDir.Right
		else:
			currentMovement = MoveDir.Left
	else:
		if abs(dir.y) >= abs(dir.x):
			currentMovement = MoveDir.Down
		elif dir.x >= 0:
			currentMovement = MoveDir.Right
		else:
			currentMovement = MoveDir.Left
		

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

func ShootProjectile():
	attackTimer = attackCooldown
	isAttacking = false
	var projectile = (enemyProjectile.instantiate() as GolemProjectile)
	projectile.position = position
	projectile.Setup(GetTextDirection(), target.position-position)
	Helper.add_to_world(projectile)

func GetTextDirection() -> String:
	match currentMovement:
		MoveDir.Up:
			return "up"
		MoveDir.Down:
			return "down"
		MoveDir.Left:
			return "left"
		MoveDir.Right:
			return "right"
	return ""

func _on_animated_sprite_2d_animation_finished():
	var animName = animationManager.get_animation()
	
	match animName:
		"damage right":
			isRecievingDamage = false
		"damage left":
			isRecievingDamage = false
		"damage up":
			isRecievingDamage = false
		"damage down":
			isRecievingDamage = false
		"attack up":
			ShootProjectile()
		"attack down":
			ShootProjectile()
		"attack right":
			ShootProjectile()
		"attack left":
			ShootProjectile()
		"death right":
			Death()
		"death left":
			Death()
		"death up":
			Death()
		"death down":
			Death()
