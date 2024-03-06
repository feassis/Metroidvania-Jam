extends Enemy

@export var avoidanceDistance: float = 100
@export var stopDistance:float =  5


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
	
	SetDirection()
		
	var curLoc = global_transform.origin
	var nextLoc = agent.get_next_path_position()
	
	if curLoc.distance_to(nextLoc) < stopDistance:
		velocity = Vector2(0,0)
		return
	
	var newVel = (nextLoc - curLoc).normalized() * speed
	velocity = newVel

	move_and_slide()

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
