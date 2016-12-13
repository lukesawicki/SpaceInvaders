extends Node2D

const LASER_BEAM_VELOCITY = -150
var isAlive=true
var myName = "FFFF"
onready var anim = get_node("InvFanim")
	
func _ready():
	set_process(true)
	anim.play("FInvaderAnim")
	
