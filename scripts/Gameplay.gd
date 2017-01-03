extends Node2D

var isShootPressed = false

# ENVIRONMENT

const MARGIN_LEFT = 0
const MARGIN_RIGHT = 672
const MARGIN_TOP = 216
const MARGIN_BOTTOM = 64
const SCREEN_WIDTH = 672
const SCREEN_HIGHT = 768
const INVADERS_ROWS_SPACE = 24
const SPACE_BETWEEN_G = 24
const SPACE_BETWEEN_F = 14
const SPACE_BETWEEN_E = 12

var screen_size

# INVADERS AND SHELTER PROPERTIES AND OTHER

const STEP = 6

const INVADERS_G_WIDTH = 24
const INVADERS_F_WIDTH = 34
const INVADERS_E_WIDTH = 36
const INVADERS_HIGHT = 24

var current_invader_width = 24

var invaders_g = preload("res://scenes/G_Invaders.tscn")
var invaders_f = preload("res://scenes/F_Invaders.tscn")
var invaders_e = preload("res://scenes/E_Invaders.tscn")

var allInvadersNames = []
var invaderPositionToCheck

var shelter = preload("res://scenes/ShelterScene.tscn")

const SHELTER_WIDTH = 66
const SHELTER_HIGHT = 48
const SHELTER_ROW_X_POSITION = 50
const SHTELER_ROW_Y_POSITION = 600
const SPACE_BETWEEN_SHELTERS = 69

var allSheltersNames = []

# SHIP PROPERTIES

var terranShipScene = preload("res://scenes/TerranShipScene.tscn")

var terranShipp

# LASER BEAM AND ROCKETS PROPERTIES

const NUMBER_OF_LASER_BEAM_INSTANCES = 1

const LASER_BEAM_WIDTH = 4
const LASER_BEAM_HIGHT = 15

var laserBeamCount = 0
var laserBeamArray = []
var temporaryLaserBeam
var shipLaserMoving = false
var laserBeamPosition = Vector2(1024, 1024)
var laserBeamPositionOutOfView = Vector2(1024, 1024)

var shipLaserBeamHitInvader = false
var shipLaserBeamHitShelter = false

var laserBeam = preload("res://scenes/LaserBeamShootScene.tscn")
var laserBeamName
var laserBeamHitTheWall = false
# OTHER VARIABLES

var player = preload("res://scenes/AllSoundsPlayer.tscn")
var stopCheckingCollisions

var timer = null
var stepDelayTime = 0.2
var canStep = true
const STEP = 6
var stepNumber = 0
var verticalStepNumber = 1
var canDoVerticalStep = false
var wasVerticalStep = true
var youDied = false

var positionX = MARGIN_LEFT
var positionY = MARGIN_TOP + INVADERS_HIGHT

#GAMEPLAY
const ePoints = 10
const fPoints = 20
const gPoints = 30
var points = 0


func _ready():
	
	#variables which are using to set start position all invaders
	var shelterPosition = Vector2(0, SHTELER_ROW_Y_POSITION)
	var shelterTemporaryPositionX = 0
	for i in range(4):
			var shelterInstance = shelter.instance()
			shelterInstance.set_name("Shelter" + str(i))
			add_child(shelterInstance)
			shelterTemporaryPositionX = shelterTemporaryPositionX + SHELTER_WIDTH + SPACE_BETWEEN_SHELTERS
			shelterPosition.x = shelterTemporaryPositionX
			get_node("Shelter" + str(i)).set_pos(shelterPosition)
			allSheltersNames.push_back("Shelter" + str(i))

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
	#setInvadersPositions()
	initializeInvaders()
	wasVerticalStep = false

	#OTHER
	timer = Timer.new()
	timer.set_wait_time(stepDelayTime)
	timer.set_active(true)
	timer.connect("timeout", self, "waitForStep")
	timer.start()
	add_child(timer)
	
	var soundsPlayer = player.instance()
	soundsPlayer.set_name("invadersSoundsPlayer")
	add_child(soundsPlayer)
	set_process(true)

	


	
func _process(delta):
	#SHELTER COLLISIONS WITH LASER BEAM
	shelterProcess()

	#INVADERS MOVING AND COLLISIONS WITH LASER BEAM
	invadersProcess()
	
	wallProcess()
	
	if shipLaserBeamHitInvader:
		get_node("invadersSoundsPlayer").invaderHit()
	shipLaserBeamHitInvader = false
	
	if shipLaserBeamHitShelter:
		get_node("invadersSoundsPlayer").invaderHit()
	shipLaserBeamHitShelter = false
	
	if laserBeamHitTheWall:
		get_node("invadersSoundsPlayer").invaderHit()
	laserBeamHitTheWall = false
		
	get_node(laserBeamName).moving = shipLaserMoving
		
	get_node("myShip").movingShip(delta)
	
	if Input.is_action_pressed("ship_shoot"):
		laserBeamPosition = get_node(laserBeamName).get_pos()
		if !shipLaserMoving:
			laserBeamPosition.y = get_node("myShip").get_pos().y
			laserBeamPosition.x = get_node("myShip").get_pos().x
			get_node(laserBeamName).set_pos(laserBeamPosition) #set laser position to the same position as ship position
			shipLaserMoving = true
			get_node("invadersSoundsPlayer").shot()

	get_node(laserBeamName).movingLaserBeam(delta)
	canStep = false
	
#CHECK COLLISIONS WITH INVADERS
func colide(invaderPosition, positionLaserBeam):
	if ((positionLaserBeam.x > invaderPosition.x - current_invader_width/2) && (positionLaserBeam.x < invaderPosition.x+current_invader_width/2) && (positionLaserBeam.y - LASER_BEAM_HIGHT/2 < invaderPosition.y + INVADERS_HIGHT/2) && (positionLaserBeam.y - LASER_BEAM_HIGHT/2 > invaderPosition.y - INVADERS_HIGHT/2) ):
		shipLaserMoving=false
		#print("K")
		return true
	else:
		#print("N")
		return false
#CHECK COLLISIONS WITH SHELTERS
func colideWithShelter(shelterPosition, positionLaserBeam):
	if ( positionLaserBeam.x > shelterPosition.x - SHELTER_WIDTH/2) && (positionLaserBeam.x < shelterPosition.x+SHELTER_WIDTH/2) && (positionLaserBeam.y - LASER_BEAM_HIGHT/2 < shelterPosition.y + SHELTER_HIGHT/2) && (positionLaserBeam.y - LASER_BEAM_HIGHT/2 > shelterPosition.y - SHELTER_HIGHT/2):
		shipLaserMoving=false
		return true
	else:
		return false
#CHECK COLLISIONS WITH TOP WALL
func colideWithWall(positionLaserBeam):
	if (positionLaserBeam.y < MARGIN_TOP):
		shipLaserMoving=false
		return true;
	else:
		return false

func waitForStep():
	canStep = true
	stepNumber = stepNumber + 1
	if( stepNumber == 5):
		stepNumber = 0
	
	print("waitForStep")
	
func initializeInvaders():
	var invaderPosition = Vector2(0, 0)
	positionX = MARGIN_LEFT
	positionY = MARGIN_TOP + INVADERS_HIGHT * verticalStepNumber
	
	for i in range(55):
		if i < 11:
			var invaderGinstance = invaders_g.instance()
			invaderGinstance.set_name("InvaderG" + str(i))
			add_child(invaderGinstance)
			if i == 0:
				positionX = positionX + INVADERS_G_WIDTH/2
			else:
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
			if i == 11 || i == 22:
				positionX = positionX + INVADERS_F_WIDTH/2
			else:
				positionX = positionX + INVADERS_F_WIDTH + SPACE_BETWEEN_F #get_node(nodeInGroup).set_pos(position, 24)
			invaderPosition.x = positionX
			invaderPosition.y = positionY
			get_node("InvaderF" + str(i)).set_pos(invaderPosition)
			allInvadersNames.push_back("InvaderF" + str(i))
		
		elif i>32 && i<55:
			if i == 33 || i == 44:
				positionX = MARGIN_LEFT
				positionY = positionY+INVADERS_ROWS_SPACE+INVADERS_HIGHT
			var invaderEinstance = invaders_e.instance()
			invaderEinstance.set_name("InvaderE" + str(i))
			add_child(invaderEinstance)
			if i == 33 || i == 44:
				positionX = positionX + INVADERS_E_WIDTH/2
			else:
				positionX = positionX + INVADERS_E_WIDTH + SPACE_BETWEEN_E  #get_node(nodeInGroup).set_pos(position, 24)
			invaderPosition.x = positionX
			invaderPosition.y = positionY
			get_node("InvaderE" + str(i)).set_pos(invaderPosition)
			allInvadersNames.push_back("InvaderE" + str(i))

func shelterProcess():
	for i in range(4):
		var laserPos = get_node(laserBeamName).get_pos()
		var someShelter = get_node(allSheltersNames[i]).get_pos()
		if colideWithShelter(someShelter, laserPos):
			shipLaserBeamHitShelter=true
			get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
			break
			
func invadersProcess():
	for i in range(55):
		print(points)
		var laserPos = get_node(laserBeamName).get_pos()
		var someInvader = get_node(allInvadersNames[i]).get_pos()
		var isAlive = get_node(allInvadersNames[i]).isAlive
		if isAlive:
			if i < 11:#G
				if someInvader.x + INVADERS_G_WIDTH/2 > MARGIN_RIGHT:
					canStep = false
					canDoVerticalStep = true
					verticalStepNumber = verticalStepNumber + 1
					wasVerticalStep = true
				if canStep && stepNumber==4:
					get_node(allInvadersNames[i]).step(STEP)
				current_invader_width = INVADERS_G_WIDTH
				if colide(someInvader, laserPos):
					get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
					shipLaserBeamHitInvader = true
					get_node(allInvadersNames[i]).set_hidden(true)
					get_node(allInvadersNames[i]).isAlive = false
					points = points + gPoints
					break
			elif i>10 && i<22:#F
				if someInvader.x + INVADERS_F_WIDTH/2 > MARGIN_RIGHT:
					canStep = false
					canDoVerticalStep = true
					verticalStepNumber = verticalStepNumber + 1
					wasVerticalStep = true
				if canStep && stepNumber==3:
					get_node(allInvadersNames[i]).step(STEP)
				current_invader_width = INVADERS_F_WIDTH
				if colide(someInvader, laserPos):
					get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
					shipLaserBeamHitInvader = true
					#get_node("invadersSoundsPlayer").invaderHit()
					get_node(allInvadersNames[i]).set_hidden(true)
					get_node(allInvadersNames[i]).isAlive = false
					points = points + fPoints
					break
			elif i>21 && i<33:#F
				if someInvader.x + INVADERS_F_WIDTH/2 > MARGIN_RIGHT:
					canStep = false
					canDoVerticalStep = true
					verticalStepNumber = verticalStepNumber + 1
					wasVerticalStep = true
				if canStep && stepNumber==2:
					get_node(allInvadersNames[i]).step(STEP)
				current_invader_width = INVADERS_F_WIDTH
				if colide(someInvader, laserPos):
					get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
					shipLaserBeamHitInvader = true
					#get_node("invadersSoundsPlayer").invaderHit()
					get_node(allInvadersNames[i]).set_hidden(true)
					get_node(allInvadersNames[i]).isAlive = false
					points = points + fPoints
					break
			elif i>32 && i<44:#E
				if someInvader.x + INVADERS_E_WIDTH/2 > MARGIN_RIGHT:
					canStep = false
					canDoVerticalStep = true
					verticalStepNumber = verticalStepNumber + 1
					wasVerticalStep = true
				if canStep && stepNumber==1:
					get_node(allInvadersNames[i]).step(STEP)
				current_invader_width = INVADERS_E_WIDTH
				#get_node(allInvadersNames[i]).step()
				if colide(someInvader, laserPos):
					get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
					shipLaserBeamHitInvader = true
					#get_node("invadersSoundsPlayer").invaderHit()
					get_node(allInvadersNames[i]).set_hidden(true)
					get_node(allInvadersNames[i]).isAlive = false
					points = points + ePoints
					break
			elif i>43 && i<55:#E
				if someInvader.x + INVADERS_E_WIDTH/2 > MARGIN_RIGHT:
					canStep = false
					canDoVerticalStep = true
					verticalStepNumber = verticalStepNumber + 1
				if canStep && stepNumber==0:
					get_node(allInvadersNames[i]).step(STEP)
				current_invader_width = INVADERS_E_WIDTH
				#get_node(allInvadersNames[i]).step()
				if colide(someInvader, laserPos):
					get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
					shipLaserBeamHitInvader = true
					#get_node("invadersSoundsPlayer").invaderHit()
					get_node(allInvadersNames[i]).set_hidden(true)
					get_node(allInvadersNames[i]).isAlive = false
					points = points + ePoints
					break
					
			if canDoVerticalStep:
				setInvadersPositions()
				canDoVerticalStep = false
				canStep = true
				wasVerticalStep = false
			else:
				wasVerticalStep = true
			
		
		if canStep && i == 10 && stepNumber==0:
			get_node("invadersSoundsPlayer").invader1()
		if canStep && i == 21 && stepNumber==1:
			get_node("invadersSoundsPlayer").invader2()
		if canStep && i == 32 && stepNumber==2:
			get_node("invadersSoundsPlayer").invader3()
		if canStep && i == 43 && stepNumber==3:
			get_node("invadersSoundsPlayer").invader4()

func wallProcess():
	var laserPos = get_node(laserBeamName).get_pos()
	if colideWithWall(laserPos):
		laserBeamHitTheWall=true
		get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)

func setInvadersPositions():
	var invaderPosition = Vector2(0, 0)
	positionX = MARGIN_LEFT
	positionY = MARGIN_TOP + INVADERS_HIGHT * verticalStepNumber
	
	for i in range(55):
		if i < 11:
			if wasVerticalStep && i == 0:
				positionX = positionX + INVADERS_G_WIDTH/2
			else:
				positionX = positionX + INVADERS_G_WIDTH + SPACE_BETWEEN_G
			invaderPosition.x = positionX
			invaderPosition.y = positionY
			get_node("InvaderG" + str(i)).set_pos(invaderPosition)
			
		elif i>10 && i<33:
			if i == 11 || i == 22:
				positionX = MARGIN_LEFT
				positionY = positionY+INVADERS_ROWS_SPACE+INVADERS_HIGHT
			if wasVerticalStep && ( i == 11 || i == 22):
				positionX = positionX + INVADERS_F_WIDTH/2
			else:
				positionX = positionX + INVADERS_F_WIDTH + SPACE_BETWEEN_F #get_node(nodeInGroup).set_pos(position, 24)
			invaderPosition.x = positionX
			invaderPosition.y = positionY
			get_node("InvaderF" + str(i)).set_pos(invaderPosition)
		
		elif i>32 && i<55:
			if i == 33 || i == 44:
				positionX = MARGIN_LEFT
				positionY = positionY+INVADERS_ROWS_SPACE+INVADERS_HIGHT
			if wasVerticalStep && ( i == 33 || i == 44):
				positionX = positionX + INVADERS_E_WIDTH/2
			else:
				positionX = positionX + INVADERS_E_WIDTH + SPACE_BETWEEN_E  #get_node(nodeInGroup).set_pos(position, 24)
			invaderPosition.x = positionX
			invaderPosition.y = positionY
			get_node("InvaderE" + str(i)).set_pos(invaderPosition)

func _on_Main_Menu_pressed():
	get_node("/root/global").goto_scene("res://scenes/MainMenu.tscn")
	
	
func _on_Exit_Game_pressed():
	get_node("/root/global").goto_scene("res://scenes/EndingScreen.tscn")