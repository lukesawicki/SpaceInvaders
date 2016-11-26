extends KinematicBody2D

const SHIP_VELOCITY = 150

var shipVelocityVector = Vector2()

func _fixed_process(delta):
	
	shipVelocityVector.y=0
	
	if(Input.is_action_pressed("ship_left")):
		if(is_colliding()):
			shipVelocityVector.x=0;
			shipVelocityVector.y=0;
		else:
			shipVelocityVector.x = -SHIP_VELOCITY
	elif(Input.is_action_pressed("ship_right")):
		if(is_colliding()):
			shipVelocityVector.x=0;
			shipVelocityVector.y=0;
		else:
			shipVelocityVector.x = SHIP_VELOCITY
	else:
		shipVelocityVector.x = 0
	
	var motion = shipVelocityVector * delta
	move(motion)
	
	
func _ready():
	set_fixed_process(true)