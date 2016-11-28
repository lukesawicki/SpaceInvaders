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

func fire():
	set_pos(Vector2(get_node("Ship").get_position().x, get_node("ship").get_position().y))
	moving = true
func _process(delta):
		if(get_pos().x < MARGIN_LEFT):
		set_pos(Vector2(MARGIN_LEFT+1, SHIP_Y))
	if(get_pos().x >  SCREEN_WIDTH - MARGIN_RIGHT):
		set_pos(Vector2( SCREEN_WIDTH - (MARGIN_RIGHT+1), SHIP_Y))
	if(moving && get_pos().x > MARGIN_LEFT && get_pos().x < SCREEN_WIDTH - MARGIN_RIGHT):
		set_pos(Vector2(get_pos().x + delta * shipVelocityVector.x, get_pos().y));
	

		
		

			
	if(get_pos().x < MARGIN_LEFT):
		set_pos(Vector2(MARGIN_LEFT+1, SHIP_Y))
	if(get_pos().x >  SCREEN_WIDTH - MARGIN_RIGHT):
		set_pos(Vector2( SCREEN_WIDTH - (MARGIN_RIGHT+1), SHIP_Y))
	if(moving && get_pos().x > MARGIN_LEFT && get_pos().x < SCREEN_WIDTH - MARGIN_RIGHT):
		set_pos(Vector2(get_pos().x + delta * shipVelocityVector.x, get_pos().y));

	
func _ready():
	set_pos(Vector2(SHIP_X, SHIP_Y));
