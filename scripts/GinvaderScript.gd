extends Node2D


const LASER_BEAM_VELOCITY = -150
var colliding=true
	
func _ready():
	set_process(true)