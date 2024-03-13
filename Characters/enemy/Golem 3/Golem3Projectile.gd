extends Area2D
class_name GolemProjectile

@export var speed : float = 80
@export var lifeTime: float = 6
@export var dmg : int = 1
@export var animationManager: AnimatedSprite2D

var life:float = 0
var dir : String = "up"
var moveDir: Vector2 = Vector2(0,0)

func _process(delta):
	life += delta
	
	if life > lifeTime:
		queue_free()
	
	position = position + moveDir.normalized() * speed * delta

func Setup(facing : String, direction : Vector2):
	dir = facing
	moveDir = direction
	PlayIdleAnim()
	
func PlayIdleAnim():
	match dir:
		"up":
			animationManager.play("idle up")
		"down":
			animationManager.play("idle down")
		"left":
			animationManager.play("idle left")
		"right":
			animationManager.play("idle right")


func _on_body_entered(body):
	if body is Player:
		(body as Player).health.TakeDamage(dmg)

