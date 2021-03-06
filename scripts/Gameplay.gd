extends Node2D

# ENVIRONMENT

const MARGIN_LEFT = 0
const MARGIN_RIGHT = 672
const MARGIN_TOP = 128
const MARGIN_BOTTOM = 710
const SCREEN_WIDTH = 672
const SCREEN_HIGHT = 768
const INVADERS_ROWS_SPACE = 24
const SPACE_BETWEEN_G = 24
const SPACE_BETWEEN_F = 14
const SPACE_BETWEEN_E = 12

var INVASION_POSITION = 648

var screen_size

#INVADERS
const INVADERS_G_WIDTH = 24
const INVADERS_F_WIDTH = 34
const INVADERS_E_WIDTH = 36
const INVADERS_HIGHT = 24

var current_invader_width = 24

var invaders_g = preload("res://scenes/G_Invaders.tscn")
var invaders_f = preload("res://scenes/F_Invaders.tscn")
var invaders_e = preload("res://scenes/E_Invaders.tscn")

var allInvadersNames = []

var STEP_LEFT =  -6
var STEP_RIGHT = 6
var STEP = STEP_RIGHT
var VERTICAL_STEP_HIGHT = 24


var stepNumber = 0
var verticalStepNumber = 1
var canDoVerticalStep = false
var wasVerticalStep = true

var positionX = MARGIN_LEFT
var positionY = MARGIN_TOP + INVADERS_HIGHT

var invaderWhichAreShootingNow = randi()%55
var shootingInvaderPosition = Vector2(0, 0)

var invadersAdditionalInfos = {}

# MYSTERY
var MYSTERY_WIDTH = 48
var MYSTERY_HIGHT = 24
var MYSTERY_Y_POSITION = 145
var mysteryPositionOutOfView = Vector2(256, -512)
var mysteryInvader = preload("res://scenes/MysteryScene.tscn")
var mysteryRun = false
var mysteryPlay = false

#SHELTERS
var shelter = preload("res://scenes/ShelterScene.tscn")

const SHELTER_WIDTH = 66
const SHELTER_HIGHT = 48

const SHTELER_ROW_Y_POSITION = 600
const SPACE_BETWEEN_SHELTERS = 69

var allSheltersNames = []

# SHIP PROPERTIES

var SHIP_WIDTH = 39
var SHIP_HIGHT = 24

var terranShipScene = preload("res://scenes/TerranShipScene.tscn")
var terranShipp
var shipLaserMoving = false

#LASER BEAM

const LASER_BEAM_WIDTH = 4
const LASER_BEAM_HIGHT = 15

var laserBeamPosition = Vector2(1024, 1024)
var laserBeamPositionOutOfView = Vector2(1024, 1024)

var shipLaserBeamHitInvader = false
var shipLaserBeamHitShelter = false

var laserBeam = preload("res://scenes/LaserBeamShootScene.tscn")
var laserBeamName
var laserBeamHitTheWall = false

#ROCKETS
const NUMBER_OF_ROCKET_INSTANCES = 4

const ROCKED_WIDTH = 4
const ROCKED_HIGHT = 15

var rocket1Position = Vector2(-64, -64)
var rocket2Position = Vector2(-64, -64)
var rocket3Position = Vector2(-64, -64)
var rocket4Position = Vector2(-64, -64)

var rocketsPositionOutOfView = Vector2(-64, -64)

var rocket1Moving = false
var rocket2Moving = false
var rocket3Moving = false
var rocket4Moving = false

var rocket1ShootingBy = "NoOne"
var rocket2ShootingBy = "NoOne"
var rocket3ShootingBy = "NoOne"
var rocket4ShootingBy = "NoOne"

var rocketNamesArray = []
var rocketMovingArray = []

var rocketScene1 = preload("res://scenes/InvaderRocket1Scene.tscn")
var rocketScene2 = preload("res://scenes/InvaderRocket2Scene.tscn")
var rocketScene3 = preload("res://scenes/InvaderRocket3Scene.tscn")

var rocketShipHit = false

#GAMEPLAY
const ePoints = 10
const fPoints = 20
const gPoints = 30
var mysteryPoints = [50, 100, 150, 300]

var numberOfShots = 0
var numberOfInvaders = 55
var numberOfCurrentVerticalStep=0


#OTHER VARIABLES

var player = preload("res://scenes/AllSoundsPlayer.tscn")

var explode = preload("res://scenes/Explosion.tscn")
var ifExplode = false
var explodeName

var invExplode = preload("res://scenes/InvaderExplosion.tscn")
var ifInvExplode = false
var invExplodeName


var timer = null
var stepDelayTime = 0.2 # lsawicki
var canStep = true

var playSound1 = false
var playSound2 = false
var playSound3 = false
var playSound4 = false

var colidedWall = false

var noteSoundTimer = null
var noteSoundDelayTime = 0.9
var noteCanPlayNote = true
var noteNumber = 0

var noteSoundDelayReduction = 0.3
var previousNumberOfInvaders = 55
var nuberOfInvadersToChangeSoundDelay = 6
var previousPointsAfterIncreasingNumberOfShips = 0 

var invasion = false

var wasShipResetPosition = false

var isPlayingAnimation = false

var previousNumberOfInvadersForSteps = 55
var nuberOfInvadersToChangeStepDelay = 6

func _ready():
	get_node("/root/global").menuMusic.stop()
	var explodeInstance = explode.instance()
	explodeName = "blow"
	explodeInstance.set_name(explodeName)
	add_child(explodeInstance)

	var invExplodeInstance = invExplode.instance()
	invExplodeName = "blow"
	explodeInstance.set_name(invExplodeName)
	add_child(invExplodeInstance)
	

	initializeShelters()
	
	initializeTerranShip()
	
	initializeLaserBeam()
	
	createListOfRockets()
	
	createListOfRandomMovingRockets()

	initializeInvaders()
	
	initializeMysteryShip()
	
	initializeTimers()

	initializeSoundPlayer()
	
	initializeGraphicalUserInterface()
	
	wasVerticalStep = false
	numberOfShots = 0
	numberOfInvaders = 55
	#get_node("/root/global").menuMusic.play()
################################ GAME MAIN LOOP ################################
func _process(delta):

	shelterProcess()
	
	rocketShelterProcess()

	laserRocketProcess()

	invadersProcess()
	
	rokcetShipProcess()
	
	wallProcess()
	
	wallRocketProcess()

	mysteryMovingCondition()

	mysteryProcess(delta)
	
	playingMusicProcess()
	
	playAllSounds()
		
	playingMusicProcess()
		
	get_node(laserBeamName).moving = shipLaserMoving
	
	get_node(rocketMovingArray[0]).moving = rocket1Moving
	get_node(rocketMovingArray[1]).moving = rocket2Moving
	get_node(rocketMovingArray[2]).moving = rocket3Moving
	get_node(rocketMovingArray[3]).moving = rocket4Moving
		
	get_node("myShip").movingShip(delta)
	
	if Input.is_action_pressed("ship_shoot"):
		laserBeamPosition = get_node(laserBeamName).get_pos()
		if !shipLaserMoving:
			laserBeamPosition.y = get_node("myShip").get_pos().y
			laserBeamPosition.x = get_node("myShip").get_pos().x
			get_node(laserBeamName).set_pos(laserBeamPosition) #set laser position to the same position as ship position
			shipLaserMoving = true
			get_node("invadersSoundsPlayer").shot()
			countShots()
			#### TESTY TESTY
			#get_node("/root/global").points = get_node("/root/global").points + 300
			#AudioServer.set_stream_global_volume_scale(0)
			#AudioServer.set_fx_global_volume_scale(0)
			
	if !rocket1Moving:
		setPositionOfShootingInvader(0)
		rocket1Position = shootingInvaderPosition
		get_node(rocketMovingArray[0]).set_pos(rocket1Position)
		rocket1Moving = true
		# tutaj wpisywac invaderowi ze strzela lsawicki
	
	if !rocket2Moving:
		setPositionOfShootingInvader(1)
		rocket2Position = shootingInvaderPosition
		get_node(rocketMovingArray[1]).set_pos(rocket2Position)
		rocket2Moving = true
	
	if !rocket3Moving:
		setPositionOfShootingInvader(2)
		rocket3Position = shootingInvaderPosition
		get_node(rocketMovingArray[2]).set_pos(rocket3Position)
		rocket3Moving = true
	
	if !rocket4Moving:
		setPositionOfShootingInvader(3)
		rocket4Position = shootingInvaderPosition
		get_node(rocketMovingArray[3]).set_pos(rocket4Position)
		rocket4Moving = true


	#for rocket in rocketMovingArray:
	get_node(rocketMovingArray[0]).movingRocket(delta)
	get_node(rocketMovingArray[1]).movingRocket(delta)
	get_node(rocketMovingArray[2]).movingRocket(delta)
	get_node(rocketMovingArray[3]).movingRocket(delta)
		
	get_node(laserBeamName).movingLaserBeam(delta)
	canStep = false
	addShipForPoints()
	shipExplosion()
	updateGraphicalUserInterface()
	
	
############################# END GAME MAIN LOOP ###############################




		
###########################**** COLLISIONS METHODS ****#########################

######################### INVADER RIGHT WALL COLLISION #########################
func invaderColideRightWall(invaderPositionX, invaderWidth):
	return invaderPositionX + invaderWidth/2 > MARGIN_RIGHT
################################################################################



########################## INVADER LEFT WALL COLLISION #########################
func invaderColideLeftWall(invaderPositionX, invaderWidth):
	return invaderPositionX - invaderWidth/2 < MARGIN_LEFT
################################################################################



######################### LASER BEAM INVADER COLLISION #########################
func laserBeamInvaderColide(invaderPosition, positionLaserBeam):
	if ( ( (positionLaserBeam.x + LASER_BEAM_WIDTH/2 > invaderPosition.x - current_invader_width/2) && (positionLaserBeam.x + LASER_BEAM_WIDTH/2 < invaderPosition.x + current_invader_width/2) ) || ( (positionLaserBeam.x - LASER_BEAM_WIDTH/2 > invaderPosition.x - current_invader_width/2) && (positionLaserBeam.x - LASER_BEAM_WIDTH/2 < invaderPosition.x + current_invader_width/2) ) ) && ( (positionLaserBeam.y-LASER_BEAM_HIGHT/2 < invaderPosition.y + INVADERS_HIGHT/2) && (positionLaserBeam.y-LASER_BEAM_HIGHT/2 > invaderPosition.y - INVADERS_HIGHT/2) ):
		shipLaserMoving=false
		return true
	else:
		return false
################################################################################



########################## LASER BEAM SHELTER COLLISON #########################
func colideWithShelter(shelterPosition, positionLaserBeam):
	if ( ( (positionLaserBeam.x + LASER_BEAM_WIDTH/2 > shelterPosition.x - SHELTER_WIDTH/2) && (positionLaserBeam.x + LASER_BEAM_WIDTH/2 < shelterPosition.x + SHELTER_WIDTH/2) ) || ( (positionLaserBeam.x - LASER_BEAM_WIDTH/2 > shelterPosition.x - SHELTER_WIDTH/2) && (positionLaserBeam.x - LASER_BEAM_WIDTH/2 < shelterPosition.x + SHELTER_WIDTH/2) ) ) && ( (positionLaserBeam.y-LASER_BEAM_HIGHT/2 < shelterPosition.y + SHELTER_HIGHT/2) && (positionLaserBeam.y-LASER_BEAM_HIGHT/2 > shelterPosition.y - SHELTER_HIGHT/2) ):
		shipLaserMoving=false
		return true
	else:
		return false
################################################################################



########################### LASER BEAM WALL COLLISION ##########################
func colideWithWall(positionLaserBeam):
	if (positionLaserBeam.y - INVADERS_HIGHT/2 < MARGIN_TOP):
		shipLaserMoving=false
		return true;
	else:
		return false
################################################################################



############################# ROCKET WALL COLLISION ############################
func rocketColideWithWall(rocketPosition, rocketNumber):
	if (rocketPosition.y > MARGIN_BOTTOM):
		if rocketNumber == 0:
			rocket1Moving=false
		elif rocketNumber == 1:
			rocket2Moving=false
		elif rocketNumber == 2:
			rocket3Moving=false
		elif rocketNumber == 3:
			rocket4Moving=false
		return true;
	else:
		return false
################################################################################


########################### ROCKET SHELTER COLLISION ###########################
func rocketColideWithShelter(rocketPosition, rocketNumber, shelterPosition):
	#if ( rocketPosition.x > shelterPosition.x - SHELTER_WIDTH/2) && (rocketPosition.x < shelterPosition.x+SHELTER_WIDTH/2) && (rocketPosition.y + ROCKED_HIGHT/2 > shelterPosition.y - SHELTER_HIGHT/2) && (rocketPosition.y + ROCKED_HIGHT/2 < shelterPosition.y + SHELTER_HIGHT/2):
	if ( ( (rocketPosition.x + ROCKED_WIDTH/2 > shelterPosition.x - SHELTER_WIDTH/2) && (rocketPosition.x + ROCKED_WIDTH/2 < shelterPosition.x + SHELTER_WIDTH/2) ) || ( (rocketPosition.x - ROCKED_WIDTH/2 > shelterPosition.x - SHELTER_WIDTH/2) && (rocketPosition.x - ROCKED_WIDTH/2 < shelterPosition.x + SHELTER_WIDTH/2) ) )   &&   ( (rocketPosition.y+ROCKED_HIGHT/2 < shelterPosition.y + SHELTER_HIGHT/2) && (rocketPosition.y+ROCKED_HIGHT/2 > shelterPosition.y - SHELTER_HIGHT/2) ):
		if rocketNumber == 0:
			rocket1Moving=false
		elif rocketNumber == 1:
			rocket2Moving=false
		elif rocketNumber == 2:
			rocket3Moving=false
		elif rocketNumber == 3:
			rocket4Moving=false
		return true;
	else:
		return false
################################################################################



########################### ROCKET SHIP COLLISION ##############################
func rocketColideWithShip(rocketPosition, rocketNumber, shipPosition):
	if (rocketPosition.x > shipPosition.x - SHIP_WIDTH/2) && (rocketPosition.x < shipPosition.x + SHIP_WIDTH/2) && (rocketPosition.y + ROCKED_HIGHT/2 > shipPosition.y - SHIP_HIGHT/2) && (rocketPosition.y + ROCKED_HIGHT/2 < shipPosition.y + SHIP_HIGHT/2):
		if rocketNumber == 0:
			rocket1Moving=false
		elif rocketNumber == 1:
			rocket2Moving=false
		elif rocketNumber == 2:
			rocket3Moving=false
		elif rocketNumber == 3:
			rocket4Moving=false
		return true;
	else:
		return false
################################################################################

########################### LASER BEAM ROCKET COLLISION ########################
func laserRocketCollision(rocketPosition, rocketNumber, laserBeamPosition):
	if (laserBeamPosition.x - LASER_BEAM_WIDTH/2 < rocketPosition.x + ROCKED_WIDTH/2) && (laserBeamPosition.x - LASER_BEAM_WIDTH/2 > rocketPosition.x - ROCKED_WIDTH/2) && (laserBeamPosition.y - LASER_BEAM_HIGHT/2 < rocketPosition.y + ROCKED_HIGHT/2) && (laserBeamPosition.y - LASER_BEAM_HIGHT/2 > rocketPosition.y - ROCKED_HIGHT/2) || (laserBeamPosition.x + LASER_BEAM_WIDTH/2 > rocketPosition.x - ROCKED_WIDTH/2) && (laserBeamPosition.x + LASER_BEAM_WIDTH/2 < rocketPosition.x + ROCKED_WIDTH/2) && (laserBeamPosition.y - LASER_BEAM_HIGHT/2 < rocketPosition.y + ROCKED_HIGHT/2) && (laserBeamPosition.y - LASER_BEAM_HIGHT/2 > rocketPosition.y - ROCKED_HIGHT/2):
		if rocketNumber == 0:
			rocket1Moving=false
		elif rocketNumber == 1:
			rocket2Moving=false
		elif rocketNumber == 2:
			rocket3Moving=false
		elif rocketNumber == 3:
			rocket4Moving=false
		shipLaserMoving=false
		return true;
	else:
		return false
################################################################################



########################### MYSTERY SHIP WALL COLLISION ########################
func mysteryWallColide():
	var mysteryPosition = get_node("mystery").get_pos()
	if(mysteryPosition.x < MARGIN_LEFT + MYSTERY_WIDTH/2):
		return true
	if(mysteryPosition.x >  MARGIN_RIGHT - MYSTERY_WIDTH/2):
		return true
################################################################################



######################## LASER BEAM MYSTERY SHIP COLLISION #####################
func mysteryLaserColide():
	var positionLaserBeam = get_node(laserBeamName).get_pos()
	var mysteryPosition = get_node("mystery").get_pos()
	if ( positionLaserBeam.x > mysteryPosition.x - MYSTERY_WIDTH/2) && (positionLaserBeam.x < mysteryPosition.x+MYSTERY_WIDTH/2) && (positionLaserBeam.y - LASER_BEAM_HIGHT/2 < mysteryPosition.y + MYSTERY_HIGHT/2) && (positionLaserBeam.y - LASER_BEAM_HIGHT/2 > mysteryPosition.y - MYSTERY_HIGHT/2):
		get_node("invadersSoundsPlayer").specialInvaderHit()
		return true
	else:
		return false
################################################################################

#########################**** END COLLISIONS METHODS ****#######################



#############################**** GAMEPLAY METHODS ****#########################

####################### SAVE INVADERS CURRENT POSITIONS ########################
func savePositions():
	for invaderName in allInvadersNames:
		invadersAdditionalInfos[invaderName] = get_node(invaderName).get_pos()
################################################################################


############### SET PREVIOUS INVADERS POSIOTIONS AS CURRENT ####################
func setPreviousPositions():
	for invaderName in allInvadersNames:
		invadersAdditionalInfos[invaderName].y = invadersAdditionalInfos[invaderName].y + VERTICAL_STEP_HIGHT
		if STEP > 0:
			get_node(invaderName).set_pos(Vector2(invadersAdditionalInfos[invaderName].x-12,invadersAdditionalInfos[invaderName].y))
		else:
			get_node(invaderName).set_pos(Vector2(invadersAdditionalInfos[invaderName].x+12,invadersAdditionalInfos[invaderName].y))
################################################################################


########################### WAITING FOR STEP INVADERS ##########################
func waitForStep():
	canStep = true
	stepNumber = stepNumber + 1
	if( stepNumber == 5):
		stepNumber = 0
################################################################################



########################### WAITING FOR PLAYING NOTE ###########################
func waitForPlayNote():
	noteCanPlayNote = true
################################################################################



#################### PLAYING SOUNDS FOR MUSIC IN GAMEPLAY ######################
func playOneNote():
	if noteCanPlayNote:
		if noteNumber==1:
			get_node("invadersSoundsPlayer").invader1()
		if noteNumber==2:
			get_node("invadersSoundsPlayer").invader2()
		if noteNumber==3:
			get_node("invadersSoundsPlayer").invader3()
		if noteNumber==4:
			get_node("invadersSoundsPlayer").invader4()
			noteNumber = 0
		noteCanPlayNote = false # WARNING THIS IS IN THE IF CONDITION
		noteNumber = noteNumber + 1
################################################################################



############## SETTING SHOOTING INVADER POSITION TO VARIABLE ###################
func setPositionOfShootingInvader(currentRocketNumber):
	var ifCanShoot = false
	var isShooting = false
	var invaderName = "NoOne"
	while !ifCanShoot && !isShooting:
		randomize()
		invaderWhichAreShootingNow = randi()%55
		ifCanShoot = get_node(allInvadersNames[invaderWhichAreShootingNow]).isAlive && invaderShootingCondition(get_node(allInvadersNames[invaderWhichAreShootingNow]).get_pos())
		##
		isShooting = get_node(allInvadersNames[invaderWhichAreShootingNow]).isShooting
		##
	if ifCanShoot:
		shootingInvaderPosition = get_node(allInvadersNames[invaderWhichAreShootingNow]).get_pos()
		get_node(rocketMovingArray[currentRocketNumber]).shootingBy = get_node(allInvadersNames[invaderWhichAreShootingNow]).get_name()
		get_node(allInvadersNames[invaderWhichAreShootingNow]).isShooting = true
################################################################################







################## SET INVADERS POSITION TO START POINT ########################
func setInvadersPositions():
	var invaderPosition = Vector2(0, 0)
	positionX = MARGIN_LEFT
	positionY = MARGIN_TOP + ( INVADERS_HIGHT/2 ) * verticalStepNumber
	
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
################################################################################


################### CREATE 12 RANDOM ROCKETS 4-ANY KIND ########################
func createListOfRockets():
	for i in range(4):
		var rocketName = "1" + str(i)
		rocketNamesArray.push_back(rocketName)
		var rocketInstance = rocketScene1.instance()
		rocketInstance.set_name(rocketName)
		add_child(rocketInstance)
		get_node(rocketName).set_pos(rocketsPositionOutOfView)

	for i in range(4):
		var rocketName = "2" + str(i)
		rocketNamesArray.push_back(rocketName)
		var rocketInstance = rocketScene2.instance()
		rocketInstance.set_name(rocketName)
		add_child(rocketInstance)
		get_node(rocketName).set_pos(rocketsPositionOutOfView)

	for i in range(4):
		var rocketName = "3" + str(i)
		rocketNamesArray.push_back(rocketName)
		var rocketInstance = rocketScene3.instance()
		rocketInstance.set_name(rocketName)
		add_child(rocketInstance)
		get_node(rocketName).set_pos(rocketsPositionOutOfView)
################################################################################


############################# MYSTERY SHIP MOVING CONDITION ####################
func mysteryMovingCondition():
	if numberOfShots == 22:
		mysteryRun = true
		mysteryPlay = true
		numberOfShots = 7
################################################################################


############################## PLAYIN ALL SOUNDS ################################################################
func playAllSounds():
	if shipLaserBeamHitInvader||laserBeamHitTheWall:
		get_node("invadersSoundsPlayer").invaderHit()
	if shipLaserBeamHitShelter:
		get_node("invadersSoundsPlayer").bunker_hit()
	if rocketShipHit:
		get_node("invadersSoundsPlayer").shipExplosion()
	if mysteryPlay:
		get_node("/root/ufscpl").play()
	if !mysteryRun:
		get_node("/root/ufscpl").stop()
	
	mysteryPlay=false
	
	rocketShipHit = false
	laserBeamHitTheWall = false
	shipLaserBeamHitInvader = false
	shipLaserBeamHitShelter = false
################################################################################


################################### ADDING POINTS ##############################
func addPoints(newPoints):
	get_node("/root/global").points = get_node("/root/global").points + newPoints
################################################################################


################################### SHOTS COUNTER ##############################
func countShots():
	numberOfShots = numberOfShots + 1
################################################################################


################################# LEFT INVADERS COUNTER ########################
func countInvadersLeft():
	numberOfInvaders = numberOfInvaders - 1
################################################################################


############################# INVADER SHOOTING CONDITION #######################
func invaderShootingCondition(shootingInvaderPosition):
	var invPosition
	var canShoot = true
	for inv in allInvadersNames:
		invPosition = get_node(inv).get_pos()
		if get_node(inv).isAlive:
			if invPosition.y > shootingInvaderPosition.y && shootingInvaderPosition.x > invPosition.x - get_node(inv).WIDTH/2 && shootingInvaderPosition.x < invPosition.x + get_node(inv).WIDTH/2:
				canShoot = false
				break
	return canShoot
################################################################################


#################### PLAYING SOUNDS OF MUSIC(FOUR SOUNDS) ######################
func playingMusicProcess():
	if previousNumberOfInvaders - numberOfInvaders == 6:
		noteSoundDelayTime = noteSoundDelayTime*0.9
		noteSoundTimer.set_wait_time(noteSoundDelayTime)
		previousNumberOfInvaders = numberOfInvaders
################################################################################


####################### ADDING NEW SHIP FOR 1500 POINTS ########################
func addShipForPoints():
	if get_node("/root/global").points - previousPointsAfterIncreasingNumberOfShips >= 1500:
		get_node("/root/global").addShip()
		previousPointsAfterIncreasingNumberOfShips = get_node("/root/global").points
################################################################################

################################# INCREASING INVADERS SPEED ####################
func increaseStepSpeedWhenInvaderDie():
	if previousNumberOfInvadersForSteps - numberOfInvaders == 6:
		stepDelayTime = stepDelayTime*0.75
		timer.set_wait_time(stepDelayTime)
		previousNumberOfInvadersForSteps = numberOfInvaders
	
################################################################################

################### CREATE SET OF RANDOM ROCKETS TO SHOTING ####################
func createListOfRandomMovingRockets():
	randomize()
	var randomRocket = randi()%12
	rocketMovingArray.push_back(rocketNamesArray[randomRocket])
	var brakuje = true
	var licznikDodanych = 1
	var nieMaTakiejRakiety = false
	while brakuje:
		randomize()
		randomRocket = randi()%12
		for i in range(0, rocketMovingArray.size()):
			if rocketMovingArray[i].to_int() !=rocketNamesArray[randomRocket].to_int():
				nieMaTakiejRakiety = true
			else:
				nieMaTakiejRakiety = false
				break
		if nieMaTakiejRakiety:
			rocketMovingArray.push_back(rocketNamesArray[randomRocket])
			licznikDodanych = licznikDodanych + 1
		if licznikDodanych != 4:
			brakuje = true
		elif licznikDodanych == 4:
			brakuje = false
################################################################################



######################### ROCKET SWAPING WHEN DESTROYED ########################
func swapDestoryedRocketWithNewRandom(destroyed):
	var wrzucilemNowa = false
	var randomRocket
	var nieMaTakiejRakiety = false
	while !wrzucilemNowa:
		randomize()
		randomRocket = randi()%12
		for i in range(0, rocketMovingArray.size()):
			if rocketMovingArray[i].to_int() !=rocketNamesArray[randomRocket].to_int():
				nieMaTakiejRakiety = true
			else:
				nieMaTakiejRakiety = false
				break
		if nieMaTakiejRakiety:
			rocketMovingArray[destroyed] = rocketNamesArray[randomRocket]
			wrzucilemNowa = true
		else:
			wrzucilemNowa = false
################################################################################

###########################**** END GAMEPLAY METHODS ****#######################


############################**** INITIALIZING METHODS ****######################

############################# INITIALIZING INVADERS ############################
func initializeInvaders():
	var invaderPosition = Vector2(0, 0)
	positionX = MARGIN_LEFT
	positionY = MARGIN_TOP + 40 + (INVADERS_HIGHT/2) * verticalStepNumber
	
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
################################################################################


############################# SHELTERS INITALIZATION ###########################
func initializeShelters():
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
################################################################################


############################# TERRAN SHIP INITALIZATION ########################
func initializeTerranShip():
	terranShipp = terranShipScene.instance()
	terranShipp.set_name("myShip")
	add_child(terranShipp)
################################################################################


############################# LASER BEAM INITALIZATION #########################
func initializeLaserBeam():
	var laserBeamInstance = laserBeam.instance()
	laserBeamInstance.set_name("LaserBeam")
	add_child(laserBeamInstance)
	get_node("LaserBeam").set_pos(laserBeamPositionOutOfView)
	laserBeamName = "LaserBeam"
################################################################################


############################# MYSTERY SHIP INITALIZATION #######################
func initializeMysteryShip():
	var mysteryInvaderInstance = mysteryInvader.instance()
	mysteryInvaderInstance.set_name("mystery")
	add_child(mysteryInvaderInstance)
################################################################################


############################# SOUND PLAYER INITALIZATION #######################
func initializeSoundPlayer():
	var soundsPlayer = player.instance()
	soundsPlayer.set_name("invadersSoundsPlayer")
	add_child(soundsPlayer)
	set_process(true)
################################################################################


########################### ALL TIMERS INITALIZATION ###########################
func initializeTimers():
	timer = Timer.new()
	timer.set_wait_time(stepDelayTime)
	timer.set_active(true)
	timer.connect("timeout", self, "waitForStep")
	timer.start()
	add_child(timer)
	
	noteSoundTimer = Timer.new()
	noteSoundTimer.set_wait_time(noteSoundDelayTime)
	noteSoundTimer.set_active(true)
	noteSoundTimer.connect("timeout", self, "waitForPlayNote")
	noteSoundTimer.start()
	add_child(noteSoundTimer)
################################################################################


############################# GUI HUD INITALIZATION ############################
func initializeGraphicalUserInterface():
	get_node("CurrentPoints").set_text(str(get_node("/root/global").points))#  + str(points))
	get_node("CurrentPoints").update()
	get_node("HightScore").set_text(str(get_node("/root/global").hiscore))#  + str(points))
	get_node("HightScore").update()
	get_node("ShipsLeft").set_text(str(get_node("/root/global").shipsLeft))
	get_node("ShipsLeft").update()
################################################################################

########################**** END INITIALIZING METHODS ****######################


###########################**** PROCESING METHODS ****##########################

################################ INVADERS PROCESS ##############################
func invadersProcess():
	var invaderNow
	for i in range(55):
		var laserPos = get_node(laserBeamName).get_pos()
		var someInvader = get_node(allInvadersNames[i]).get_pos()
		var isAlive = get_node(allInvadersNames[i]).isAlive
		invaderNow = someInvader
		if isAlive:
			if someInvader.y+INVADERS_HIGHT/2 >= INVASION_POSITION:
				invasion = true
				break
			if i < 11:#G
				if invaderColideRightWall(someInvader.x, INVADERS_G_WIDTH)||invaderColideLeftWall(someInvader.x, INVADERS_G_WIDTH):
					colidedWall = true
					canStep = false
					canDoVerticalStep = true
					verticalStepNumber = verticalStepNumber + 1
					wasVerticalStep = true
					break
				if canStep && stepNumber==4:
					get_node(allInvadersNames[i]).step(STEP)
				current_invader_width = INVADERS_G_WIDTH
				if laserBeamInvaderColide(someInvader, laserPos):
					get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
					shipLaserBeamHitInvader = true
					get_node(allInvadersNames[i]).set_hidden(true)
					get_node(allInvadersNames[i]).isAlive = false
					addPoints(gPoints)
					countInvadersLeft()
					ifInvExplode = true
					break
			elif i>10 && i<22:#F
				if invaderColideRightWall(someInvader.x, INVADERS_F_WIDTH)||invaderColideLeftWall(someInvader.x, INVADERS_F_WIDTH):
					colidedWall = true
					canStep = false
					canDoVerticalStep = true
					verticalStepNumber = verticalStepNumber + 1
					wasVerticalStep = true
					break
				if canStep && stepNumber==3:
					get_node(allInvadersNames[i]).step(STEP)
				current_invader_width = INVADERS_F_WIDTH
				if laserBeamInvaderColide(someInvader, laserPos):
					get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
					shipLaserBeamHitInvader = true
					get_node(allInvadersNames[i]).set_hidden(true)
					get_node(allInvadersNames[i]).isAlive = false
					addPoints(fPoints)
					countInvadersLeft()
					ifInvExplode = true
					break
			elif i>21 && i<33:#F
				if invaderColideRightWall(someInvader.x, INVADERS_F_WIDTH)||invaderColideLeftWall(someInvader.x, INVADERS_F_WIDTH):
					colidedWall = true
					canStep = false
					canDoVerticalStep = true
					verticalStepNumber = verticalStepNumber + 1
					wasVerticalStep = true
					break
				if canStep && stepNumber==2:
					get_node(allInvadersNames[i]).step(STEP)
				current_invader_width = INVADERS_F_WIDTH
				if laserBeamInvaderColide(someInvader, laserPos):
					get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
					shipLaserBeamHitInvader = true
					get_node(allInvadersNames[i]).set_hidden(true)
					get_node(allInvadersNames[i]).isAlive = false
					addPoints(fPoints)
					countInvadersLeft()
					ifInvExplode = true
					break
			elif i>32 && i<44:#E
				if invaderColideRightWall(someInvader.x, INVADERS_E_WIDTH)||invaderColideLeftWall(someInvader.x, INVADERS_E_WIDTH):
					colidedWall = true
					canStep = false
					canDoVerticalStep = true
					verticalStepNumber = verticalStepNumber + 1
					wasVerticalStep = true
					break
				if canStep && stepNumber==1:
					get_node(allInvadersNames[i]).step(STEP)
				current_invader_width = INVADERS_E_WIDTH
				if laserBeamInvaderColide(someInvader, laserPos):
					get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
					shipLaserBeamHitInvader = true
					get_node(allInvadersNames[i]).set_hidden(true)
					get_node(allInvadersNames[i]).isAlive = false
					addPoints(ePoints)
					countInvadersLeft()
					ifInvExplode = true
					break
			elif i>43 && i<55:#E
				if invaderColideRightWall(someInvader.x, INVADERS_E_WIDTH)||invaderColideLeftWall(someInvader.x, INVADERS_E_WIDTH):
					colidedWall = true
					canStep = false
					canDoVerticalStep = true
					verticalStepNumber = verticalStepNumber + 1
					break
				if canStep && stepNumber==0:
					get_node(allInvadersNames[i]).step(STEP)
				current_invader_width = INVADERS_E_WIDTH
				if laserBeamInvaderColide(someInvader, laserPos):
					get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
					shipLaserBeamHitInvader = true
					get_node(allInvadersNames[i]).set_hidden(true)
					get_node(allInvadersNames[i]).isAlive = false
					addPoints(ePoints)
					countInvadersLeft()
					ifInvExplode = true
					break
	# lsawicki
	if shipLaserBeamHitInvader:
		increaseStepSpeedWhenInvaderDie()
	
	if !colidedWall:
		savePositions()
		
	colidedWall = false
	if canDoVerticalStep:
		setPreviousPositions()
		numberOfCurrentVerticalStep = numberOfCurrentVerticalStep + 1
		STEP = STEP * -1
		canDoVerticalStep = false
		canStep = true
		wasVerticalStep = false
	else:
		wasVerticalStep = true
	invaderExplosion(invaderNow)
	playOneNote()
#################################################################################################################
func invaderExplosion(invaderPosition):
	if ifInvExplode:
		get_node(invExplodeName).set_pos(Vector2(invaderPosition.x, invaderPosition.y))
		get_node(invExplodeName).blowItUp()
	ifInvExplode = false
################################################################################


################################# MYSTERY SHIP PROCESS #########################
func mysteryProcess(delta):
	if mysteryWallColide():
		get_node("mystery").moving = false
		mysteryRun = false
		get_node("mystery").set_pos(mysteryPositionOutOfView)
	elif mysteryLaserColide():
		get_node("mystery").moving = false
		mysteryRun = false
		get_node("mystery").set_pos(mysteryPositionOutOfView)
		addPoints(mysteryPoints[randomFromZeroTo(4)])
	else:
		if !get_node("mystery").moving:
			if mysteryRun:
				get_node("mystery").drawIfMovingAndDirection()
				if get_node("mystery").velocity < 0:
					get_node("mystery").set_pos(Vector2(MARGIN_RIGHT - ((MYSTERY_WIDTH/2)+2), MYSTERY_Y_POSITION))
				elif get_node("mystery").velocity > 0:
					get_node("mystery").set_pos(Vector2(MARGIN_LEFT + ((MYSTERY_WIDTH/2)+2), MYSTERY_Y_POSITION))
					
				get_node("mystery").moving = true
				
	get_node("mystery").movingMastery(delta)
################################################################################


########################## LASER BEAM SHELTER PROCESS ##########################
func shelterProcess():
	for i in range(4):
		var laserPos = get_node(laserBeamName).get_pos()
		var someShelter = get_node(allSheltersNames[i]).get_pos()
		if colideWithShelter(someShelter, laserPos):
			shipLaserBeamHitShelter=true
			get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
			break
################################################################################


############################ LASER BEAM WALL PROCESS ###########################
func wallProcess():
	var laserPos = get_node(laserBeamName).get_pos()
	if colideWithWall(laserPos):
		laserBeamHitTheWall=true
		get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
################################################################################


########################### LASER BEAM ROCKET PROCESS #########################
###############################################################################################################################
func laserRocketProcess():
	var laserPosition = get_node(laserBeamName).get_pos()
	var poz = get_node(rocketMovingArray[0]).get_pos()
	
	var ifDestroy = randomFromZeroTo(get_node(rocketMovingArray[0]).destroingProbability)
	if ifDestroy == 1:
		if laserRocketCollision(poz,0,laserPosition):
			if get_node(get_node(rocketMovingArray[0]).shootingBy) != null:
				get_node(get_node(rocketMovingArray[0]).shootingBy).isShooting = false
			get_node(rocketMovingArray[0]).set_pos(rocketsPositionOutOfView)
			get_node(rocketMovingArray[0]).shootingBy = "NoOne"
			swapDestoryedRocketWithNewRandom(0)
			get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)

	poz = get_node(rocketMovingArray[1]).get_pos()
	var ifDestory = randomFromZeroTo(get_node(rocketMovingArray[1]).destroingProbability)
	if ifDestroy == 1:
		if laserRocketCollision(poz,1,laserPosition):
			if get_node(get_node(rocketMovingArray[1]).shootingBy) != null:
				get_node(get_node(rocketMovingArray[1]).shootingBy).isShooting = false
			get_node(rocketMovingArray[1]).set_pos(rocketsPositionOutOfView)
			get_node(rocketMovingArray[1]).shootingBy = "NoOne"
			swapDestoryedRocketWithNewRandom(1)
			get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)

	poz = get_node(rocketMovingArray[2]).get_pos()
	var ifDestory = randomFromZeroTo(get_node(rocketMovingArray[2]).destroingProbability)
	if ifDestroy == 1:
		if laserRocketCollision(poz,2,laserPosition):
			if get_node(get_node(rocketMovingArray[2]).shootingBy) != null:
				get_node(get_node(rocketMovingArray[2]).shootingBy).isShooting = false
			get_node(rocketMovingArray[2]).set_pos(rocketsPositionOutOfView)
			get_node(rocketMovingArray[2]).shootingBy = "NoOne"
			swapDestoryedRocketWithNewRandom(2)
			get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)

	poz = get_node(rocketMovingArray[3]).get_pos()
	var ifDestory = randomFromZeroTo(get_node(rocketMovingArray[0]).destroingProbability)
	if ifDestroy == 1:
		if laserRocketCollision(poz,3,laserPosition):
			if get_node(get_node(rocketMovingArray[3]).shootingBy) != null:
				get_node(get_node(rocketMovingArray[3]).shootingBy).isShooting = false
			get_node(rocketMovingArray[3]).set_pos(rocketsPositionOutOfView)
			get_node(rocketMovingArray[3]).shootingBy = "NoOne"
			swapDestoryedRocketWithNewRandom(3)
			get_node(laserBeamName).set_pos(laserBeamPositionOutOfView)
################################################################################


############################## ROCKET WALL PROCESS #############################
func wallRocketProcess():
	var poz
	poz = get_node(rocketMovingArray[0]).get_pos()
	if rocketColideWithWall(poz,0):
		get_node(rocketMovingArray[0]).set_pos(rocketsPositionOutOfView)
		if get_node(get_node(rocketMovingArray[0]).shootingBy) != null:
			get_node(get_node(rocketMovingArray[0]).shootingBy).isShooting = false
		get_node(rocketMovingArray[0]).shootingBy = "NoOne"
		swapDestoryedRocketWithNewRandom(0)
	
	poz = get_node(rocketMovingArray[1]).get_pos()
	if rocketColideWithWall(poz,1):
		get_node(rocketMovingArray[1]).set_pos(rocketsPositionOutOfView)
		if get_node(get_node(rocketMovingArray[1]).shootingBy) != null:
			get_node(get_node(rocketMovingArray[1]).shootingBy).isShooting = false
		get_node(rocketMovingArray[1]).shootingBy = "NoOne"
		swapDestoryedRocketWithNewRandom(1)
	
	poz = get_node(rocketMovingArray[2]).get_pos()
	if rocketColideWithWall(poz,2):
		get_node(rocketMovingArray[2]).set_pos(rocketsPositionOutOfView)
		if get_node(get_node(rocketMovingArray[2]).shootingBy) != null:
			get_node(get_node(rocketMovingArray[2]).shootingBy).isShooting = false
		get_node(rocketMovingArray[2]).shootingBy = "NoOne"
		swapDestoryedRocketWithNewRandom(2)
	
	poz = get_node(rocketMovingArray[3]).get_pos()
	if rocketColideWithWall(poz,3):
		get_node(rocketMovingArray[3]).set_pos(rocketsPositionOutOfView)
		if get_node(get_node(rocketMovingArray[3]).shootingBy) != null:
			get_node(get_node(rocketMovingArray[3]).shootingBy).isShooting = false
		get_node(rocketMovingArray[3]).shootingBy = "NoOne"
		swapDestoryedRocketWithNewRandom(3)
################################################################################


############################ ROCKET SHELTER PROCESS ############################
func rocketShelterProcess():
	for i in range(4):
		var someShelterPosition = get_node(allSheltersNames[i]).get_pos()
		var poz = get_node(rocketMovingArray[0]).get_pos()
		if rocketColideWithShelter(poz,0,someShelterPosition):
			get_node(rocketMovingArray[0]).set_pos(rocketsPositionOutOfView)
			if get_node(get_node(rocketMovingArray[0]).shootingBy) != null:
				get_node(get_node(rocketMovingArray[0]).shootingBy).isShooting = false
			get_node(rocketMovingArray[0]).shootingBy = "NoOne"
			swapDestoryedRocketWithNewRandom(0)

		poz = get_node(rocketMovingArray[1]).get_pos()
		if rocketColideWithShelter(poz,1,someShelterPosition):
			get_node(rocketMovingArray[1]).set_pos(rocketsPositionOutOfView)
			if get_node(get_node(rocketMovingArray[1]).shootingBy) != null:
				get_node(get_node(rocketMovingArray[1]).shootingBy).isShooting = false
			get_node(rocketMovingArray[1]).shootingBy = "NoOne"
			swapDestoryedRocketWithNewRandom(1)

		poz = get_node(rocketMovingArray[2]).get_pos()
		if rocketColideWithShelter(poz,2,someShelterPosition):
			get_node(rocketMovingArray[2]).set_pos(rocketsPositionOutOfView)
			if get_node(get_node(rocketMovingArray[2]).shootingBy) != null:
				get_node(get_node(rocketMovingArray[2]).shootingBy).isShooting = false
			get_node(rocketMovingArray[2]).shootingBy = "NoOne"
			swapDestoryedRocketWithNewRandom(2)

		poz = get_node(rocketMovingArray[3]).get_pos()
		if rocketColideWithShelter(poz,3,someShelterPosition):
			get_node(rocketMovingArray[3]).set_pos(rocketsPositionOutOfView)
			if get_node(get_node(rocketMovingArray[3]).shootingBy) != null:
				get_node(get_node(rocketMovingArray[3]).shootingBy).isShooting = false
			get_node(rocketMovingArray[3]).shootingBy = "NoOne"
			swapDestoryedRocketWithNewRandom(3)
################################################################################


###################### ROCKET PROCESS (ON SHIP COLLISION) ######################
func rokcetShipProcess():
	var shipPosition = get_node("myShip").get_pos()
	var poz = get_node(rocketMovingArray[0]).get_pos()
	if rocketColideWithShip(poz,0,shipPosition):
		get_node(rocketMovingArray[0]).set_pos(rocketsPositionOutOfView)
		get_node(get_node(rocketMovingArray[0]).shootingBy).isShooting = false
		get_node(rocketMovingArray[0]).shootingBy = "NoOne"
		swapDestoryedRocketWithNewRandom(0)
		get_node("/root/global").subtractShip()
		rocketShipHit = true
		ifExplode = true

	poz = get_node(rocketMovingArray[1]).get_pos()
	if rocketColideWithShip(poz,1,shipPosition):
		get_node(rocketMovingArray[1]).set_pos(rocketsPositionOutOfView)
		get_node(get_node(rocketMovingArray[1]).shootingBy).isShooting = false
		get_node(rocketMovingArray[1]).shootingBy = "NoOne"
		swapDestoryedRocketWithNewRandom(1)
		get_node("/root/global").subtractShip()
		rocketShipHit = true
		ifExplode = true

	poz = get_node(rocketMovingArray[2]).get_pos()
	if rocketColideWithShip(poz,2,shipPosition):
		get_node(rocketMovingArray[2]).set_pos(rocketsPositionOutOfView)
		get_node(get_node(rocketMovingArray[2]).shootingBy).isShooting = false
		get_node(rocketMovingArray[2]).shootingBy = "NoOne"
		swapDestoryedRocketWithNewRandom(2)
		get_node("/root/global").subtractShip()
		rocketShipHit = true
		ifExplode = true

	poz = get_node(rocketMovingArray[3]).get_pos()
	if rocketColideWithShip(poz,3,shipPosition):
		get_node(rocketMovingArray[3]).set_pos(rocketsPositionOutOfView)
		get_node(get_node(rocketMovingArray[3]).shootingBy).isShooting = false
		get_node(rocketMovingArray[3]).shootingBy = "NoOne"
		swapDestoryedRocketWithNewRandom(3)
		get_node("/root/global").subtractShip()
		rocketShipHit = true
		ifExplode = true
	


	#if !ifExplode:
	#	get_node(explodeName).stopBlowing()
func shipExplosion():
	if ifExplode:

		var shipPos = get_node("myShip").get_pos()
		get_node("myShip").set_pos(Vector2(128, -1024))
		get_node(explodeName).set_pos(Vector2(shipPos.x, shipPos.y))
		get_node(explodeName).blowItUp()
		print(str(get_node(explodeName).get_frame()))
		resetShipPosition()
	ifExplode = false
	
################################################################################


#########################**** END PROCESING METHODS ****########################

################################  OTHER  #######################################
func _on_Main_Menu_pressed():
	get_node("/root/global").goto_scene("res://scenes/MainMenu.tscn")
	
func _on_Exit_Game_pressed():
	get_node("/root/global").goto_scene("res://scenes/EndingScreen.tscn")

func randomFromZeroTo(upperLimit):
	var randomNumber = randi()%upperLimit
	return randomNumber
func resetShipPosition():
	get_node("myShip").set_pos(Vector2(MARGIN_LEFT + SHIP_WIDTH/2+1,660))

############################## GUI OR HUD UPDATE ###############################
func updateGraphicalUserInterface():
	get_node("/root/global").checkIfYouAreHiScore()
	get_node("CurrentPoints").set_text(str(get_node("/root/global").points))
	get_node("CurrentPoints").update()
	get_node("HightScore").set_text(str(get_node("/root/global").hiscore))
	get_node("HightScore").update()
	get_node("ShipsLeft").set_text(str(get_node("/root/global").shipsLeft))
	get_node("ShipsLeft").update()
	if get_node("/root/global").checkIfYouDied() || invasion:
		get_node("/root/global").points = 0
		get_node("/root/global").shipsLeft = 3
		get_node("/root/global").goto_scene("res://scenes/GameOver.tscn")
	if numberOfInvaders <= 0:
		get_node("/root/global").goto_scene("res://scenes/EndGame.tscn")
		#get_tree().reload_current_scene()
################################################################################
