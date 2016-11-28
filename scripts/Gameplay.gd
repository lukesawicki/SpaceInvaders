extends Node2D

var screen_size

var invader_width = 24
var invader_hight = 24
var left_direction = -1
var right_direction = 1
var spaceHorisontal = 24
var spaceVertical = 24
var counter = 0
var positionX = 0
var positionY = 40
var space=24
var moving = false


var SHIP_VELOCITY = 150
var SHIP_Y = 384
var SHIP_X = 336
var MARGIN_LEFT = 150
var MARGIN_RIGHT = 150
var MARGIN_TOP = 20
var MARGIN_BOTTOM = 64
var SCREEN_WIDTH = 672
var SCREEN_HIGHT = 768

var shipVelocityVector = Vector2()



func _ready():
#	screen_size = get_viewport().
	get_node("Ship").set_pos(Vector2(SHIP_X, SHIP_Y));


	var invader_width = 24
	var invader_hight = 24
	
	var nodesInGroupG = get_tree().get_nodes_in_group("InvadersG")
	var nodesInGroupE = get_tree().get_nodes_in_group("InvadersF")
	var nodesInGroupF = get_tree().get_nodes_in_group("InvadersE")
	
	for nodeInGroup in nodesInGroupG:
		counter+=1
		positionX = positionX + invader_width+space #get_node(nodeInGroup).set_pos(position, 24)
		nodeInGroup.set_pos(Vector2(positionX, positionY))
	

	counter = 0
	positionX = 0
	positionY = positionY+48
	for nodeInGroup in nodesInGroupF:
		counter+=1
		positionX = positionX + invader_width+space #get_node(nodeInGroup).set_pos(position, 24)
		nodeInGroup.set_pos(Vector2(positionX, positionY))
		if(counter==11):
			# zmienna y i jego zmiana w if
			positionY=positionY+48
			positionX=0
		
	counter=0
	positionX=0
	positionY = positionY+48
	for nodeInGroup in nodesInGroupE:
		counter+=1
		positionX = positionX + invader_width+space #get_node(nodeInGroup).set_pos(position, 24)
		nodeInGroup.set_pos(Vector2(positionX, positionY))
		if(counter==11):
			# zmienna y i jego zmiana w if
			positionY=positionY+48
			positionX=0
		
		
	#for nodeInGroup in groupG:
		
		

	set_process(true)

func _process(delta):
	if(Input.is_action_pressed("ship_left")):
		shipVelocityVector.x = -SHIP_VELOCITY
		moving = true
	elif(Input.is_action_pressed("ship_right")):
		shipVelocityVector.x = SHIP_VELOCITY
		moving = true
	else:
		shipVelocityVector.x = 0
		moving = false
		
	if(get_node("Ship").get_pos().x < MARGIN_LEFT):
		get_node("Ship").set_pos(Vector2(MARGIN_LEFT+1, SHIP_Y))
	if(get_node("Ship").get_pos().x >  SCREEN_WIDTH - MARGIN_RIGHT):
		get_node("Ship").set_pos(Vector2( SCREEN_WIDTH - (MARGIN_RIGHT+1), SHIP_Y))
		
	if(moving && get_node("Ship").get_pos().x > MARGIN_LEFT && get_node("Ship").get_pos().x < SCREEN_WIDTH - MARGIN_RIGHT):
		get_node("Ship").set_pos(Vector2(get_node("Ship").get_pos().x + delta * shipVelocityVector.x, get_node("Ship").get_pos().y));

	
func _on_Main_Menu_pressed():
	get_node("/root/global").goto_scene("res://scenes/MainMenu.tscn")
	
	
func _on_Exit_Game_pressed():
	get_node("/root/global").goto_scene("res://scenes/EndingScreen.tscn")