extends Node2D

var screen_size
var ship_size
const SHIP_SPEED = 150


func _ready():
	# Initalization here
	screen_size = get_viewport_rect().size
	ship_size = get_node("Ship/ShipSprite").get_texture().get_size()
	set_process(true)
	
	
func _process(delta):
	var ship_rect = Rect2( get_node("Ship/ShipSprite").get_pos() - ship_size*0.5, ship_size)
	
	var ship_pos = get_node("Ship/ShipSprite").get_pos()
	
	if (ship_pos.x > 0 and Input.is_action_pressed("ship_left")):
		ship_pos.x += -SHIP_SPEED * delta
	if (ship_pos.x < screen_size.x and Input.is_action_pressed("ship_right")):
		ship_pos.x += SHIP_SPEED * delta
		
	get_node("Ship/ShipSprite").set_pos(ship_pos)
		
func _on_Main_Menu_pressed():
	get_node("/root/global").goto_scene("res://scenes/MainMenu.tscn")
	
	
func _on_Exit_Game_pressed():
	get_node("/root/global").goto_scene("res://scenes/EndingScreen.tscn")