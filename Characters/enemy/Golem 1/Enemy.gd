extends CharacterBody2D
class_name Enemy

@export var agent: NavigationAgent2D
@export var speed: float = 50
@export var avoidanceRange: float = 15

var target: Player = null
var hasTouchedPlayer:bool = false
var wasDevoured: bool = false
 
func _process(delta):
	if wasDevoured:
		return
	
	if target == null:
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
	
	move_and_slide()

func onContactTarget():
	if hasTouchedPlayer:
		return
	
	hasTouchedPlayer = target.Kill()
	
func GetDevoured():
	wasDevoured = true
	self.queue_free()
	

func _on_detection_area_body_entered(body):
	print(body.name)
	if body is Player:
		target = (body as Player)


func _on_detection_area_body_exited(body):
	if body == target:
		target = null
