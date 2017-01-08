extends Node2D


var SHIP_VELOCITY = 150
var MARGIN_LEFT = 0
var MARGIN_RIGHT = 672
var MARGIN_TOP = 216
var MARGIN_BOTTOM = 96
var SHIP_WIDTH = 39
var SHIP_HIGHT = 24

var SHIP_Y = 660
var SHIP_X = MARGIN_LEFT + SHIP_WIDTH/2+1

var SCREEN_WIDTH = 672
var SCREEN_HIGHT = 768

var shipVelocityVector = Vector2()
var moving = false
var movingRight = true

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
		
			
	if(get_pos().x < MARGIN_LEFT+SHIP_WIDTH/2):
		set_pos(Vector2(MARGIN_LEFT + (SHIP_WIDTH/2 + 1), SHIP_Y))
	if(get_pos().x >  MARGIN_RIGHT - SHIP_WIDTH/2):
		set_pos(Vector2( MARGIN_RIGHT - (SHIP_WIDTH/2 + 1), SHIP_Y))
	if(moving && get_pos().x > MARGIN_LEFT && get_pos().x < MARGIN_RIGHT):
		set_pos(Vector2(get_pos().x + delta * shipVelocityVector.x, get_pos().y));
	
func _ready():
	set_pos(Vector2(SHIP_X, SHIP_Y))
	set_process(true)