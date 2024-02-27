extends Node2D
class_name Health

@export var initialMaxHP : int = 5
var maxHP:  int
var currentHP: int
var healthUI : HealthUI


# Called when the node enters the scene tree for the first time.
func _ready():
	maxHP = initialMaxHP
	currentHP = maxHP

func SubscribeUI(ui: HealthUI):
	healthUI = ui
	healthUI.Setup(currentHP, maxHP)

func TakeDamage(dmg : int):
	self.get_parent().PlayDamageAnim()
	currentHP = clamp(currentHP - dmg, 0, maxHP)
	healthUI.UpdateHP(currentHP)
	
	if currentHP <= 0:
		self.get_parent().PlayDeathAnimation()
	
func Heal(amount : int):
	currentHP = clamp(currentHP + amount, 0, maxHP)
	healthUI.UpdateHP(currentHP)
	
func HealMaxAmount():
	Heal(maxHP)
	
func Kill():
	TakeDamage(currentHP)
	
func HalfLife():
	TakeDamage(max(currentHP/2, 1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		TakeDamage(1)
