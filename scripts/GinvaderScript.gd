extends Node2D


const LASER_BEAM_VELOCITY = -150
var colliding=true
onready var anim = get_node("InvGanim")
	
func _ready():
	set_process(true)
	anim.play("GInvaderAnim")
	
