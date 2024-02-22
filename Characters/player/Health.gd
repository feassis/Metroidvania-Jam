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
	currentHP = clamp(currentHP - dmg, 0, maxHP)
	healthUI.UpdateHP(currentHP)
	
func Heal(amount : int):
	currentHP = clamp(currentHP - amount, 0, maxHP)
	healthUI.UpdateHP(currentHP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		TakeDamage(1)
