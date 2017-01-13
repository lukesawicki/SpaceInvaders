extends Node2D


const ROCKET_VELOCITY = 170
var moving = false
var shootingBy = "NoOne"
var destroingProbability = 5
func movingRocket(delta):
	if moving:
		set_pos(Vector2(get_pos().x, get_pos().y + delta * ROCKET_VELOCITY));
	
func changeState(isMoving):
	moving = isMoving
	
func _ready():
	set_process(true)