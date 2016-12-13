extends Node2D

const LASER_BEAM_VELOCITY = -150
var isAlive=true
var myName = "GGGG"
onready var anim = get_node("InvGanim")
	
func _ready():
	set_process(true)
	anim.play("GInvaderAnim")
	
