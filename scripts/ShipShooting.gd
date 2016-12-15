extends Node2D


const LASER_BEAM_VELOCITY = -150
var moving = false

func movingLaserBeam(delta):
	if moving:
		set_pos(Vector2(get_pos().x, get_pos().y + delta * LASER_BEAM_VELOCITY));
	
func changeState(isMoving):
	moving = isMoving
	
func _ready():
	set_process(true)