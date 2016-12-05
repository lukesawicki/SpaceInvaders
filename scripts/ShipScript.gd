extends Node2D


const SHIP_VELOCITY = 150
var SHIP_Y = 384
var SHIP_X = 336
var MARGIN_LEFT = 150
var MARGIN_RIGHT = 150
var MARGIN_TOP = 20
var MARGIN_BOTTOM = 64
var SCREEN_WIDTH = 672
var SCREEN_HIGHT = 768
var shipVelocityVector = Vector2()
var moving = false

func movingShip(delta):
	if(Input.is_action_pressed("ship_left")):
		shipVelocityVector.x = -SHIP_VELOCITY
		moving = true
	elif(Input.is_action_pressed("ship_right")):
		shipVelocityVector.x = SHIP_VELOCITY
		moving = true
	else:
		shipVelocityVector.x = 0
		moving = false
		
			
	if(get_pos().x < MARGIN_LEFT):
		set_pos(Vector2(MARGIN_LEFT+1, SHIP_Y))
	if(get_pos().x >  SCREEN_WIDTH - MARGIN_RIGHT):
		set_pos(Vector2( SCREEN_WIDTH - (MARGIN_RIGHT+1), SHIP_Y))
	if(moving && get_pos().x > MARGIN_LEFT && get_pos().x < SCREEN_WIDTH - MARGIN_RIGHT):
		set_pos(Vector2(get_pos().x + delta * shipVelocityVector.x, get_pos().y));


#func _process(delta):
#	pass
	
func _ready():
	set_pos(Vector2(SHIP_X, SHIP_Y));
	set_process(true)