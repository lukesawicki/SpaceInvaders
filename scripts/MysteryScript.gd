extends Node2D

const ROCKET_VELOCITY_RIGHT = 170
const ROCKET_VELOCITY_LEFT = -170

var velocity = ROCKET_VELOCITY_RIGHT

var moving = false

func movingMastery(delta):
	if moving:
		set_pos(Vector2(get_pos().x + delta * velocity, get_pos().y));
	else:
		pass
func changeState(isMoving):
	moving = isMoving
	
func _ready():
	set_process(true)
	
func drawIfMovingAndDirection():
	if !moving:
		randomize()
		var directionNumber = randi()%2
		if directionNumber == 1:
			velocity = ROCKET_VELOCITY_RIGHT
		elif directionNumber == 0:
			velocity = ROCKET_VELOCITY_LEFT