extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initalization here
	pass

#add to scene_a.gd

func _on_Start_pressed():
	get_node("/root/global").goto_scene("res://scenes/Gameplay.tscn")
	
func _on_Credits_pressed():
	get_node("/root/global").goto_scene("res://scenes/Credits.tscn")
	
func _on_ExitGame_pressed():
	get_node("/root/global").goto_scene("res://scenes/EndingScreen.tscn")