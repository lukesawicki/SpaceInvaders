extends Node2D

func _ready():
	set_process(true)

func _process(delta):
	pass
	
func _on_Main_Menu_pressed():
	get_node("/root/global").goto_scene("res://scenes/MainMenu.tscn")
	
	
func _on_Exit_Game_pressed():
	get_node("/root/global").goto_scene("res://scenes/EndingScreen.tscn")