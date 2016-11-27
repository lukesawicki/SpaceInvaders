extends Node2D

var screen_size

var invader_width = 24
var invader_hight = 24
var left_direction = -1
var right_direction = 1
var space = 24

var position = 0
func _ready():
#	screen_size = get_viewport().
	var invader_width = 24
	var invader_hight = 24
	
	var nodesInGroupG = get_tree().get_nodes_in_group("InvadersG")
	
	for nodeInGroup in nodesInGroupG:
		position = position + invader_width+space #get_node(nodeInGroup).set_pos(position, 24)
		nodeInGroup.set_pos(Vector2(position, 24))
		
	#for nodeInGroup in groupG:
		
		

	set_process(true)

func _process(delta):
	pass
	
func _on_Main_Menu_pressed():
	get_node("/root/global").goto_scene("res://scenes/MainMenu.tscn")
	
	
func _on_Exit_Game_pressed():
	get_node("/root/global").goto_scene("res://scenes/EndingScreen.tscn")