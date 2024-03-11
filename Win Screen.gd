extends Control

@onready var button: Button = $"Button"



func _on_button_pressed():
	get_tree().quit()
