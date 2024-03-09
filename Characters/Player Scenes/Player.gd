extends CharacterBody2D
class_name Player

@export_category("Movement")
@export var speed:float = 100.0
@export var sprintSpeed:float = 300.0
@export var dashVelocity: float = 500.0

@export_category("Animation")
@export var animManager : AnimatedSprite2D

@export_category("Health and Life")
@export var initialMaxHP: int = 5
@export var initialLifeAmount: int = 3
@export var health: Health

@export_category("Devour")
@export var devourFrameDelay: int = 8
@export var timer : Timer

@export_category("Abilities")
@export var unlockedAbilities : Array[BaseAbility] = []
var currentSkillIndex: int = 3

@export_category("Reset Ability")
@export var respawnPoint: Node2D

@export_category("DeathScreen")
@export var deathScene: DeathScreen
@export var fullDeathScene: DeathScreen

@onready var UpDetection : DevourDetection = %UP
@onready var DownDetection : DevourDetection = $"Devour Detection/Down"
@onready var RightDetection : DevourDetection = $"Devour Detection/Right"
@onready var LeftDetection : DevourDetection = $"Devour Detection/Left"

@onready var normalAbility : BaseAbility = $Abilities/ProjectileAbility
@onready var resetAbility : BaseAbility = $Abilities/ResetAbility
@onready var pulseAbility : BaseAbility = $Abilities/PulseAbility
@onready var bombAbility : BaseAbility = $Abilities/BombAbility

var isDevouring : bool = false
var isTakingDamage: bool = false

var currentLife : int
var lifeUI: LifeUI

var devourModeTimer: float = 0

var currentMovement: MoveDir= MoveDir.Down
var startPos
var isDead: bool= false




func _ready():
	PlayAnimMove(Vector2(0,0))
	
func IsInvulnerable() -> bool:
	return isDevouring || isTakingDamage || isDead

func IsOnDevourMode() -> bool:
	return devourModeTimer > 0;
	
func DevourMode(duration: float):
	devourModeTimer = duration

func _physics_process(delta):
	HandleSkillChange()
	
	if devourModeTimer > 0:
		devourModeTimer -= delta
	
	if isDevouring || isTakingDamage || isDead:
		return
	
	PlayerMovement(delta)
	
	if Input.is_action_just_pressed("devour"):
		DevourAction(delta)
		
	if Input.is_action_just_pressed("skill"):
		if len(unlockedAbilities) == 0:
			return
		if unlockedAbilities[GetSkillIndex()]:
			unlockedAbilities[GetSkillIndex()].use(self)

func GetSkillIndex() -> int:
	return abs(currentSkillIndex % len(unlockedAbilities)) 

func SubscribeHealthUI(ui : HealthUI):
	health.SubscribeUI(ui)
	
func SubscribeLifeUI(ui : LifeUI):
	lifeUI = ui
	currentLife = initialLifeAmount
	lifeUI.UpdateLife(currentLife)

func GetSpeed() -> float:
	if Input.is_action_pressed("sprint"):
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
	
func HalfLife():
	health.HalfLife()

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
	match currentMovement:
		MoveDir.Up:
			UpDetection.Devour(self)
		MoveDir.Down:
			DownDetection.Devour(self)
		MoveDir.Left:
			LeftDetection.Devour(self)
		MoveDir.Right:
			RightDetection.Devour(self)
			
	isDevouring = false
	
enum Skill {NormalAttack, Reset, Pulse, Bomb}

func UnlockSkill(skill : Skill):
	match skill:
		Skill.NormalAttack:
			if unlockedAbilities.find(normalAbility) != -1:
				return
			unlockedAbilities.append(normalAbility)
		Skill.Reset:
			if unlockedAbilities.find(resetAbility)  != -1:
				return
			unlockedAbilities.append(resetAbility)
		Skill.Pulse:
			if unlockedAbilities.find(pulseAbility) != -1:
				return
			unlockedAbilities.append(pulseAbility)
		Skill.Bomb:
			if unlockedAbilities.find(bombAbility) != -1:
				return
			unlockedAbilities.append(bombAbility)

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

func HandleSkillChange():
	if Input.is_action_just_pressed("next skill"):
		currentSkillIndex += 1
	
	if Input.is_action_just_pressed("previous skill"):
		currentSkillIndex -=1

func PlayDeathAnimation():
	isDead = true
	deathScene.Show()
	match currentMovement:
		MoveDir.Up:
			animManager.play("death up")
		MoveDir.Down:
			animManager.play("death down")
		MoveDir.Left:
			animManager.play("death left")
		MoveDir.Right:
			animManager.play("death right")

func ProcessDeath():
	if currentLife <= 0:
		print("Game Over")
	else:
		currentLife = clamp(currentLife - 1, 0, 99999)
		position = respawnPoint.position
		health.HealMaxAmount()
		isTakingDamage = false
		isDead = false
		lifeUI.UpdateLife(currentLife)
		
func GainLife(amount: int):
	currentLife += amount
	lifeUI.UpdateLife(currentLife)

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
		"death up":
			ProcessDeath()
		"death down":
			ProcessDeath()
		"death right":
			ProcessDeath()
		"death left":
			ProcessDeath()
			

