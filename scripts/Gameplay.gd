extends Node2D

var terranShipScene = preload("res://scenes/TerranShipScene.tscn")
var terranShipp
var laserBeam = preload("res://scenes/LaserBeamShootScene.tscn")

var invaders_g = preload("res://scenes/G_Invaders.tscn")
var invaders_f = preload("res://scenes/F_Invaders.tscn")
var invaders_e = preload("res://scenes/E_Invaders.tscn")

var allInvaders = []

var laserBeamCount = 0
var laserBeamArray = []
var temporaryLaserBeam

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
var shipLaserMoving = false
var laserBeamPosition

var isShootPressed = false

var MARGIN_LEFT = 20
var MARGIN_RIGHT = 150
var MARGIN_TOP = 20
var MARGIN_BOTTOM = 64
var SCREEN_WIDTH = 672
var SCREEN_HIGHT = 768

var INVADERS_G_WIDTH = 24
var INVADERS_F_WIDTH = 33
var INVADERS_E_WIDTH = 36

var LASER_BEAM_WIDTH = 4
var LASER_BEAM_HIGHT = 15

var INVADERS_HIGHT = 24

var INVADERS_ROWS_SPACE = 24

var SPACE_BETWEEN_G = 24
var SPACE_BETWEEN_F = 15
var SPACE_BETWEEN_E = 12

var invaderPositionToCheck
var laserBeamPositionToCheck

var shipVelocityVector = Vector2()



func _ready():

	
	terranShipp = terranShipScene.instance()
	terranShipp.set_name("myShip")
	add_child(terranShipp)
	
	
	for i in range(1):
		var laserBeamInstance = laserBeam.instance()
		laserBeamInstance.set_name("LaserBeam" + str(i))
		add_child(laserBeamInstance)
		var laserBeamPosition = get_node("LaserBeam"+str(i)).get_pos()
		laserBeamPosition.y= -32#400#get_node("Ship").get_pos().y
		laserBeamPosition.x = -32 #500+i*20#get_node("Ship").get_pos().x
		get_node("LaserBeam" + str(i)).set_pos(laserBeamPosition)
		laserBeamArray.push_back("LaserBeam" + str(i))
	

	positionY = MARGIN_TOP
	positionX = MARGIN_LEFT
	for i in range(55):
		if i < 11:
			var invaderGinstance = invaders_g.instance()
			invaderGinstance.set_name("InvaderG" + str(i))
			add_child(invaderGinstance)
			positionX = positionX + INVADERS_G_WIDTH + SPACE_BETWEEN_G
			var invaderPosition = Vector2(positionX, positionY)
			get_node("InvaderG" + str(i)).set_pos(invaderPosition)
			allInvaders.push_back("InvaderG" + str(i))
			
		elif i>10 && i<33:
			if i == 11 || i == 22:
				positionX = MARGIN_LEFT
				positionY = positionY+INVADERS_ROWS_SPACE+INVADERS_HIGHT
			var invaderFinstance = invaders_f.instance()
			invaderFinstance.set_name("InvaderF" + str(i))
			add_child(invaderFinstance)
			positionX = positionX + INVADERS_F_WIDTH + SPACE_BETWEEN_F #get_node(nodeInGroup).set_pos(position, 24)
			var invaderPosition = Vector2(positionX, positionY)
			get_node("InvaderF" + str(i)).set_pos(invaderPosition)
			allInvaders.push_back("InvaderF" + str(i))
		
		elif i>32 && i<55:
			if i==33 || i == 44:
				positionX = MARGIN_LEFT
				positionY = positionY+INVADERS_ROWS_SPACE+INVADERS_HIGHT
			var invaderEinstance = invaders_e.instance()
			invaderEinstance.set_name("InvaderE" + str(i))
			add_child(invaderEinstance)
			positionX = positionX + INVADERS_E_WIDTH + SPACE_BETWEEN_E #get_node(nodeInGroup).set_pos(position, 24)
			var invaderPosition = Vector2(positionX, positionY)
			get_node("InvaderE" + str(i)).set_pos(invaderPosition)
			allInvaders.push_back("InvaderE" + str(i))

	set_process(true)

func _process(delta):
	# checking if any bullet is out of level if it is then shoot
	for i in range(55):
		var laserPos = get_node(laserBeamArray[0]).get_pos()
		var someInvader = get_node(allInvaders[i]).get_pos()
		if i < 11:#G
			if colide(INVADERS_G_WIDTH, INVADERS_HIGHT, someInvader, LASER_BEAM_WIDTH, LASER_BEAM_HIGHT, laserPos):
				break
		elif i>10 && i<33:#F
			if colide(INVADERS_F_WIDTH, INVADERS_HIGHT, someInvader, LASER_BEAM_WIDTH, LASER_BEAM_HIGHT, laserPos):
				break
		elif i>32 && i<55:#E
			if colide(INVADERS_E_WIDTH, INVADERS_HIGHT, someInvader, LASER_BEAM_WIDTH, LASER_BEAM_HIGHT, laserPos):
				break
	get_node(laserBeamArray[0]).moving = shipLaserMoving
	get_node("myShip").movingShip(delta)
	
	if Input.is_action_pressed("ship_shoot"):
		if !isShootPressed:
			for oneLaserBeam in laserBeamArray:
				laserBeamCount = laserBeamCount + 1
				laserBeamPosition = get_node(oneLaserBeam).get_pos()
				if !shipLaserMoving:#laserBeamPosition.y < 0:
					laserBeamPosition.y = get_node("myShip").get_pos().y
					laserBeamPosition.x = get_node("myShip").get_pos().x
					get_node(oneLaserBeam).set_pos(laserBeamPosition) #set laser position to the same position as ship position
					get_node(oneLaserBeam).moving = true
					break
			isShootPressed = true
	else:
		isShootPressed = false
	for oneLaserBeam in laserBeamArray:
		get_node(oneLaserBeam).shooting(delta)

func fire():
	laserBeamCount = laserBeamCount+1
	
func colide(width, hight, position, widthLaserBeam, hightLaserBeam, positionLaserBeam):
	if (positionLaserBeam.y < 0) || (positionLaserBeam.x > position.x - width/2) && (positionLaserBeam.x < position.x+width/2) && (positionLaserBeam.y - hightLaserBeam/2 < position.y + hight/2) && (positionLaserBeam.y - hightLaserBeam/2 > position.y - hight/2):
		shipLaserMoving=false
		return true
	else:
		shipLaserMoving=true
		return false
	
func _on_Main_Menu_pressed():
	get_node("/root/global").goto_scene("res://scenes/MainMenu.tscn")
	
	
func _on_Exit_Game_pressed():
	get_node("/root/global").goto_scene("res://scenes/EndingScreen.tscn")