extends TextureRect

@export var opacityCurve : Curve
@export var darknessCurve : Curve

var opacityCurrentTime = 0
var darknessCurrentTime = 0
var opacity : float
var opacityChangeTime
var darknessChangeTime

var finishedUpdate : bool
var changeDarkness : bool

func _ready():
	opacity = opacityCurve.sample(opacityCurrentTime)
	
func Init(fullOpacityChangeTime, fullDarknessChangeTime):
	opacityChangeTime = fullOpacityChangeTime
	darknessChangeTime = fullDarknessChangeTime
	opacityCurrentTime = 0
	darknessCurrentTime = 0
	

func Update(delta):
	if (opacityCurrentTime < opacityChangeTime):
		opacityCurrentTime += delta
		opacity = opacityCurve.sample(opacityCurrentTime / opacityChangeTime)
		material.set_shader_parameter("opacity", opacity)
		if(opacity >= 1):
			changeDarkness = true
	if(changeDarkness and darknessCurrentTime < darknessChangeTime):
		darknessCurrentTime += delta
		var darkness = darknessCurve.sample(darknessCurrentTime / darknessChangeTime)
		material.set_shader_parameter("dark_value", darkness)
	if(opacityCurrentTime >= opacityChangeTime and darknessCurrentTime >= darknessChangeTime):
		finishedUpdate = true
