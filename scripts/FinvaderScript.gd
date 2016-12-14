extends Node2D

const LASER_BEAM_VELOCITY = -150
var isAlive=true
onready var anim = get_node("InvFanim")
	
func _ready():
	set_process(true)
	anim.play("FInvaderAnim")
	
func step(step):
	set_pos(Vector2(get_pos().x + step, get_pos().y))