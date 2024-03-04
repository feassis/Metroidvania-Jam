extends HBoxContainer
class_name LifeUI

@export var text: Label
@export var player:Player

func _ready():
	player.SubscribeLifeUI(self)

func UpdateLife(lifes: int):
	text.text = str(lifes)
