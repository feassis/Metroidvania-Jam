extends TextureRect

@export var curve : Curve

var blurCurrentTime = 0
var time

var finishedUpdate : bool

func Init(fullTime): 
	time = fullTime
	blurCurrentTime = 0
	finishedUpdate = false

func Update(delta):
	if (blurCurrentTime < time):
		blurCurrentTime += delta
		var blur = curve.sample(blurCurrentTime / time)
		material.set_shader_parameter("blur_power", blur)
	else:
		finishedUpdate = true
