extends Node2D

var terranShipScene = preload("res://scenes/TerranShipScene.tscn")
var terranShipp
var laserBeam = preload("res://scenes/LaserBeamShootScene.tscn")

var invaders_g = preload("res://scenes/G_Invaders.tscn")
var invaders_f = preload("res://scenes/F_Invaders.tscn")
var invaders_e = preload("res://scenes/E_Invaders.tscn")

var allInvaders = []


#var dominionInstance
#var nodesInTheDominion
var laserBeamCount = 0
var laserBeamArray = []
var temporaryLaserBeam
#var laserBeamPosition

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

var INVADERS_HIGHT = 24

var INVADERS_ROWS_SPACE = 24

var SPACE_BETWEEN_G = 24
var SPACE_BETWEEN_F = 15
var SPACE_BETWEEN_E = 12

var invaderPositionToCheck

var shipVelocityVector = Vector2()




func _ready():
#	screen_size = get_viewport().
	#get_node("Ship").set_pos(Vector2(SHIP_X, SHIP_Y));



	#var invader_width = 24
	#var invader_hight = 24
	
		#if laserBeamCount < 3:
	#	laserBeamCount = laserBeamCount + 1
	#	var laserBeamInstance = laserBeam.instance()
	#	laserBeamInstance.set_name("laser" + str(laserBeamCount))
	#	#print("fire"+laserBeamInstance.get_name())
	#	add_child(laserBeamInstance)
	#	var laserBeamPosition = get_node("laser"+str(laserBeamCount)).get_pos()
	#	laserBeamPosition.y= get_node("Ship").get_pos().y
	#	laserBeamPosition.x = get_node("Ship").get_pos().x
	#	get_node("laser" + str(laserBeamCount)).set_pos(laserBeamPosition)
	#	laserBeamArray.push_back("laser" + str(laserBeamCount))
	
	terranShipp = terranShipScene.instance()
	terranShipp.set_name("myShip")
	add_child(terranShipp)
	
	for i in range(3):
		var laserBeamInstance = laserBeam.instance()
		laserBeamInstance.set_name("LaserBeam" + str(i))
		add_child(laserBeamInstance)
		var laserBeamPosition = get_node("LaserBeam"+str(i)).get_pos()
		laserBeamPosition.y= -32#400#get_node("Ship").get_pos().y
		laserBeamPosition.x = -32 #500+i*20#get_node("Ship").get_pos().x
		get_node("LaserBeam" + str(i)).set_pos(laserBeamPosition)
		laserBeamArray.push_back("LaserBeam" + str(i))
		print("tworze stateczek numer", i)
	
	#### tworzenie invadersow
	
#	var nodesInGroupG = get_tree().get_nodes_in_group("InvadersG")
#	var nodesInGroupE = get_tree().get_nodes_in_group("InvadersF")
#	var nodesInGroupF = get_tree().get_nodes_in_group("InvadersE")
	

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
	
#	for i in range(55):
#		if i < 11:
#			invaderPositionToCheck = get_node("InvaderG" + str(i)).get_pos()
#		elif i>10 && i<33:
#			invaderPositionToCheck = get_node("InvaderF" + str(i)).get_pos()
#		elif i>32 && i<55:
#			invaderPositionToCheck = get_node("InvaderE" + str(i)).get_pos()
		
	
	get_node("myShip").movingShip(delta)
	if Input.is_action_pressed("ship_shoot"):
		if !isShootPressed:
			for oneLaserBeam in laserBeamArray:
				laserBeamCount = laserBeamCount + 1
				print("first in for loop")
				laserBeamPosition = get_node(oneLaserBeam).get_pos()
				if laserBeamPosition.y < 0:
					print("out of screen")
					laserBeamPosition.y = get_node("myShip").get_pos().y
					laserBeamPosition.x = get_node("myShip").get_pos().x
					get_node(oneLaserBeam).set_pos(laserBeamPosition)
					get_node(oneLaserBeam).moving = true
					print("ustawione ", laserBeamPosition)
					break
			isShootPressed = true	
	else:
		isShootPressed = false
	
	for oneLaserBeam in laserBeamArray:
		get_node(oneLaserBeam).shooting(delta)
		
	
	#var laserId = 0
	#for laser in laserBeamArray:
	#	var laserPos = get_node(laser).get_pos()
	#	laserPos.y = laserPos.y - 150 * delta
	#	get_node(laser).set_pos(laserPos)
	#	if laserPos.y < 0:
	#		remove_child(get_node(laser))
	#		laserBeamArray.remove(laserId)
	#		laserBeamCount = laserBeamCount - 1
	#	laserId = laserId + 1
	
	var i = 0
	for OneInvader in allInvaders:
		if i < 11:
			var invaderPosition = get_node("InvaderG" + str(i)).get_pos()
			for laserBeamOne in laserBeamArray:
				var laserBeamPosition = get_node(laserBeamOne).get_pos()
#				if laserBeamPosition.x+INVADERS_G_WIDTH/2 > invaderPosition.x-INVADERS_G_WIDTH/2 && laserBeamPosition.x-INVADERS_G_WIDTH/2 > invaderPosition.x-INVADERS_G_WIDTH/2 || laserBeamPosition.y-INVADERS_G_HIGHT/2
			
		elif i>10 && i<33:  
			get_node("InvaderF" + str(i)).get_pos()
		elif i>32 && i<55:
			get_node("InvaderE" + str(i)).get_pos()
		i=i+1
			
func fire():
	laserBeamCount = laserBeamCount+1
	#if laserBeamCount < 3:
	#	laserBeamCount = laserBeamCount + 1
	#	var laserBeamInstance = laserBeam.instance()
	#	laserBeamInstance.set_name("laser" + str(laserBeamCount))
	#	#print("fire"+laserBeamInstance.get_name())
	#	add_child(laserBeamInstance)
	#	var laserBeamPosition = get_node("laser"+str(laserBeamCount)).get_pos()
	#	laserBeamPosition.y= get_node("Ship").get_pos().y
	#	laserBeamPosition.x = get_node("Ship").get_pos().x
	#	get_node("laser" + str(laserBeamCount)).set_pos(laserBeamPosition)
	#	laserBeamArray.push_back("laser" + str(laserBeamCount))
	
	#print(laserBeamArray)
	

func _on_Main_Menu_pressed():
	get_node("/root/global").goto_scene("res://scenes/MainMenu.tscn")
	
	
func _on_Exit_Game_pressed():
	get_node("/root/global").goto_scene("res://scenes/EndingScreen.tscn")