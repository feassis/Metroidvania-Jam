extends Control
class_name HealthUI

@export var healthHolder : HBoxContainer
@export var heartUIPrefab : PackedScene
@export var player : Player

var maxHP : int
var currentHP : int



var hearts : Array[HeartUI] = []

func _ready():
	player.SubscribeHealthUI(self)

# Called when the node enters the scene tree for the first time.
func Setup(currentHP: int, maxHP: int):
	self.maxHP = maxHP
	self.currentHP = currentHP
	
	InstantiateHearts()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func UpdateHP(currentHP: int):
	self.currentHP = currentHP
	for i in len(hearts):
		hearts[i].ToggleActive(i < currentHP)
		

func InstantiateHearts():
	for i in len(hearts):
		hearts[i].queue_free()
	
	hearts = []
	
	for i in maxHP:
		var newHeart = heartUIPrefab.instantiate() as HeartUI
		healthHolder.add_child(newHeart)
		newHeart.ToggleActive(i < currentHP)
		hearts.append(newHeart)
