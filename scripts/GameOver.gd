extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initalization here
	pass

#add to scene_a.gd

func _on_BackToMenu_pressed():
	get_node("/root/global").goto_scene("res://scenes/MainMenu.tscn")
	
func _on_TryAgain_pressed():
	get_node("/root/global").goto_scene("res://scenes/Gameplay.tscn")
