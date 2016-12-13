extends Node2D



var isShootPressed = false

# ENVIRONMENT

var MARGIN_LEFT = 20
var MARGIN_RIGHT = 150
var MARGIN_TOP = 20
var MARGIN_BOTTOM = 64
var SCREEN_WIDTH = 672
var SCREEN_HIGHT = 768
var INVADERS_ROWS_SPACE = 24
var SPACE_BETWEEN_G = 24
var SPACE_BETWEEN_F = 15
var SPACE_BETWEEN_E = 12

var screen_size

# INVADERS PROPERTIES

var INVADERS_G_WIDTH = 24
var INVADERS_F_WIDTH = 33
var INVADERS_E_WIDTH = 36
var INVADERS_HIGHT = 24

var current_invader_width = 24

var invaders_g = preload("res://scenes/G_Invaders.tscn")
var invaders_f = preload("res://scenes/F_Invaders.tscn")
var invaders_e = preload("res://scenes/E_Invaders.tscn")

var allInvadersNames = []

var invaderPositionToCheck

# SHIP PROPERTIES

var terranShipScene = preload("res://scenes/TerranShipScene.tscn")

var terranShipp

# LASER BEAM AND ROCKETS PROPERTIES

var NUMBER_OF_LASER_BEAM_INSTANCES = 1

var LASER_BEAM_WIDTH = 4
var LASER_BEAM_HIGHT = 15

var laserBeamCount = 0
var laserBeamArray = []
var temporaryLaserBeam
var shipLaserMoving = false
var laserBeamPosition = Vector2(1024, 1024)
var laserBeamPositionOutOfView = Vector2(1024, 1024)


var laserBeam = preload("res://scenes/LaserBeamShootScene.tscn")
var laserBeamName
# OTHER VARIABLES

var stopCheckingCollisions

func _ready():
	
	#variables which are using to set start position all invaders
	var positionX = MARGIN_TOP
	var positionY = MARGIN_LEFT

	#Create ship instance and 
	terranShipp = terranShipScene.instance()
	terranShipp.set_name("myShip")
	add_child(terranShipp)
	
	#Create laser beam instances:

	var laserBeamInstance = laserBeam.instance()
	laserBeamInstance.set_name("LaserBeam")
	add_child(laserBeamInstance)
	get_node("LaserBeam").set_pos(laserBeamPositionOutOfView)
	laserBeamName = "LaserBeam"
	
	#Create all invaders ships
	var invaderPosition = Vector2()
	for i in range(55):
		if i < 11:
			var invaderGinstance = invaders_g.instance()
			invaderGinstance.set_name("InvaderG" + str(i))
			add_child(invaderGinstance)
			positionX = positionX + INVADERS_G_WIDTH + SPACE_BETWEEN_G
			invaderPosition.x = positionX
			invaderPosition.y = positionY
			get_node("InvaderG" + str(i)).set_pos(invaderPosition)
			allInvadersNames.push_back("InvaderG" + str(i))
			
		elif i>10 && i<33:
			if i == 11 || i == 22:
				positionX = MARGIN_LEFT
				positionY = positionY+INVADERS_ROWS_SPACE+INVADERS_HIGHT
			var invaderFinstance = invaders_f.instance()
			invaderFinstance.set_name("InvaderF" + str(i))
			add_child(invaderFinstance)
			positionX = positionX + INVADERS_F_WIDTH + SPACE_BETWEEN_F #get_node(nodeInGroup).set_pos(position, 24)
			invaderPosition.x = positionX
			invaderPosition.y = positionY
			get_node("InvaderF" + str(i)).set_pos(invaderPosition)
			allInvadersNames.push_back("InvaderF" + str(i))
		
		elif i>32 && i<55:
			if i==33 || i == 44:
				positionX = MARGIN_LEFT
				positionY = positionY+INVADERS_ROWS_SPACE+INVADERS_HIGHT
			var invaderEinstance = invaders_e.instance()
			invaderEinstance.set_name("InvaderE" + str(i))
			add_child(invaderEinstance)
			positionX = positionX + INVADERS_E_WIDTH + SPACE_BETWEEN_E #get_node(nodeInGroup).set_pos(position, 24)
			invaderPosition.x = positionX
			invaderPosition.y = positionY
			get_node("InvaderE" + str(i)).set_pos(invaderPosition)
			allInvadersNames.push_back("InvaderE" + str(i))

	set_process(true)

func _process(delta):
	# checking if any bullet is out of level if it is then shoot
	for i in range(55):
		var laserPos = get_node(laserBeamName).get_pos()
		var someInvader = get_node(allInvadersNames[i]).get_pos()
		if i < 11:#G
			current_invader_width = INVADERS_G_WIDTH
			if colide(someInvader, laserPos):
				get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
				break
		elif i>10 && i<33:#F
			current_invader_width = INVADERS_F_WIDTH
			if colide(someInvader, laserPos):
				get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
				break
		elif i>32 && i<55:#E
			current_invader_width = INVADERS_E_WIDTH
			if colide(someInvader, laserPos):
				get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
				break

	get_node(laserBeamName).moving = shipLaserMoving
		
	get_node("myShip").movingShip(delta)
	
	if Input.is_action_pressed("ship_shoot"):
		laserBeamPosition = get_node(laserBeamName).get_pos()
		if !shipLaserMoving:
			laserBeamPosition.y = get_node("myShip").get_pos().y
			laserBeamPosition.x = get_node("myShip").get_pos().x
			get_node(laserBeamName).set_pos(laserBeamPosition) #set laser position to the same position as ship position
			shipLaserMoving = true

	get_node(laserBeamName).movingLaserBeam(delta)
	
func colide(invaderPosition, positionLaserBeam):
	if (positionLaserBeam.y < MARGIN_TOP) || ((positionLaserBeam.x > invaderPosition.x - current_invader_width/2) && (positionLaserBeam.x < invaderPosition.x+current_invader_width/2) && (positionLaserBeam.y - LASER_BEAM_HIGHT/2 < invaderPosition.y + INVADERS_HIGHT/2) && (positionLaserBeam.y - LASER_BEAM_HIGHT/2 > invaderPosition.y - INVADERS_HIGHT/2) ):
		shipLaserMoving=false
		print("K")
		return true
	else:
		print("N")
		return false
	
func _on_Main_Menu_pressed():
	get_node("/root/global").goto_scene("res://scenes/MainMenu.tscn")
	
	
func _on_Exit_Game_pressed():
	get_node("/root/global").goto_scene("res://scenes/EndingScreen.tscn")