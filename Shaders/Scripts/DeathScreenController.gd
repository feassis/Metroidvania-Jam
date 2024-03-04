extends Control
class_name DeathScreen

@export var blurChangeTime : float
@export var opacityChangeTime : float
@export var darknessChangeTime : float
@export var fullDeath : bool

var _node : Node
var _blurNode : Node
var _noiseNode : Node
var _textNode : Node

var shouldProcess : bool

func _ready():
	_node = get_node(".")
	_blurNode = get_node("Blur")
	_noiseNode = get_node("StaticNoise")
	if(fullDeath):
		_textNode = get_node("YouDiedTextLabel")

func Show():
	print("Death Show Called")
	_node.visible = true
	_blurNode.Init(blurChangeTime)
	_noiseNode.Init(opacityChangeTime, darknessChangeTime)
	shouldProcess = true

func Hide():
	_node.visible = false
	shouldProcess = false
	
func _process(delta):
	if shouldProcess:
		UpdateShaders(delta)
	
func UpdateShaders(delta):
	if (!_noiseNode.finishedUpdate or !_blurNode.finishedUpdate):
		if (fullDeath):
			_textNode.SetOpacity(_noiseNode.opacity)
			if(darknessChangeTime > 0 and _noiseNode.opacity >= 1 and !_textNode.visible):
				_textNode.visible = true
		_blurNode.Update(delta)
		_noiseNode.Update(delta)
	else: if(fullDeath):
		_textNode.visible = false
		shouldProcess = false
