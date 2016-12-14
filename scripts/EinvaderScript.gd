extends Node2D

var timer
var canStep = false
var stepDelayTime = 2
const LASER_BEAM_VELOCITY = -150
var isAlive=true
onready var anim = get_node("InvEanim")
	
func _ready():
	timer = Timer.new()
	timer.set_wait_time(stepDelayTime)
	timer.set_active(true)
	timer.connect("timeout", self, "waitForStep")
	timer.set_one_shot(true)
	timer.start()
	add_child(timer)

	set_process(true)
	anim.play("EInvaderAnim")
	
func step(step):

	if(canStep):
		set_pos(Vector2(get_pos().x + step, get_pos().y))
	#canStep = false
	
func waitForStep():
	canStep = true
	print("waitForStep")
