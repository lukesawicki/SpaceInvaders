extends Node2D

const LASER_VELOCITY = 50
var LACER_Y = 384
var LACER_X = 336
var MARGIN_TOP = 0
var MARGIN_BOTTOM = 64
var SCREEN_WIDTH = 672
var SCREEN_HIGHT = 768
var laserBeamVector = Vector2()
var moving = false
#var visible = false
var collidable = false
var nodeTest

#func fire(startX, startY):
#	set_pos(Vector2(get_tree().get_root().get_node("Ship").get_pos().x, get_node("ship").get_pos().y))
#	moving = true
#	collidable = true
#	laserBeamVector.x = -LASER_VELOCITY
	#get_tree().get_root().get_node("parent")
#func _process(delta):
#	pass
	
#func laserBeamMoving()
	#if(get_pos().y < MARGIN_TOP):
	#	set_pos(Vector2(-64, 384))
	#	moving = false
	#	collidable = false
	#else:
	#	moving = true
	#	collidable = true
		
	#if(moving):
	#	set_pos(Vector2(get_pos().x, get_pos().y + delta * laserBeamVector.y));

	#if(get_pos().x >  SCREEN_WIDTH - MARGIN_RIGHT):
		#set_pos(Vector2( SCREEN_WIDTH - (MARGIN_RIGHT+1), LACER_Y))
	#if(moving && get_pos().x > MARGIN_LEFT && get_pos().x < SCREEN_WIDTH - MARGIN_RIGHT):
		#set_pos(Vector2(get_pos().x + delta * shipVelocityVector.x, get_pos().y));
func kurwa():
		#set_pos(Vector2(366, 384));
	#set_pos(Vector2(get_tree().get_root().get_node("Ship").get_pos().x, get_tree().get_root().get_node("ship").get_pos().y))
	pass

func _ready():
	
	#nodeTest = get_node("/root/scripts/Ship");
	var sss = Vector2(get_node(".").get_pos().x, get_node(".").get_pos().y);
	set_pos(sss)s