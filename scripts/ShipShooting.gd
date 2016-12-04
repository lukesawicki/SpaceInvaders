extends Node2D


const LASER_BEAM_VELOCITY = -250
var moving = false

func shooting(delta):
	if moving:
		set_pos(Vector2(get_pos().x, get_pos().y + delta * LASER_BEAM_VELOCITY));
	
func _ready():
	set_process(true)