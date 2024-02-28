extends Node2D
class_name PulseWave

@export var finishingSize: float = 15
@export var pulseLifeTime: float = 1.5

var elapsedTime: float = 0
var stunDuration: float = 5
var knockbackSpeed: float = 10
var knockbackDuration: float = 1

func _process(delta):
	elapsedTime = clamp(elapsedTime + delta, 0, pulseLifeTime)
	
	scale = Vector2(1, 1) * (elapsedTime / pulseLifeTime) * finishingSize
	
	if elapsedTime >= pulseLifeTime:
		self.queue_free()

func _on_area_2d_body_entered(body):
	print(body.name)
	if body is Enemy:
		(body as Enemy).Stun(stunDuration)
		(body as Enemy).Knockback((body.position - position).normalized(), knockbackSpeed, knockbackDuration)
	##Destroy Projectile stuff##


