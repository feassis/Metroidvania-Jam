extends Area2D
class_name DevourDetection

var enemies: Array[Enemy] = []
var spiritChieldren: Array[SpiritChieldrenBase] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Devour(player : Player):
	for i in len(enemies):
		enemies[i].GetDevoured()
	
	enemies.clear()
	
	for i in len(spiritChieldren):
		spiritChieldren[i].GetDevoured(player)
	
	spiritChieldren.clear()


func _on_body_entered(body):
	if body is Enemy:
		enemies.append((body as Enemy))
	
	


func _on_body_exited(body):
	if body is Enemy:
		enemies.erase((body as Enemy))
		
	if body is SpiritChieldrenBase:
		spiritChieldren.erase((body as SpiritChieldrenBase))


func _on_area_entered(area):
	if area is SpiritChieldrenBase:
		spiritChieldren.append((area as SpiritChieldrenBase))


func _on_area_exited(area):
	if area is SpiritChieldrenBase:
		spiritChieldren.erase((area as SpiritChieldrenBase))
