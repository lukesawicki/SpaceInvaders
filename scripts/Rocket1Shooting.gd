extends Node2D


const ROCKET_VELOCITY = 80
var moving = false

func movingRocket(delta):
	if moving:
		set_pos(Vector2(get_pos().x, get_pos().y + delta * ROCKET_VELOCITY));
	
func changeState(isMoving):
	moving = isMoving
	
func _ready():
	set_process(true)