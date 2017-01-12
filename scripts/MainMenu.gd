extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initalization here
	pass

#add to scene_a.gd

func _on_StartNormal_pressed():
	get_node("/root/global").goto_scene("res://scenes/Gameplay.tscn")

func _on_CreditsNormal_pressed():
	get_node("/root/global").goto_scene("res://scenes/Credits.tscn")

func _on_EndingNormal_pressed():
	get_tree().quit()

func _on_StartNormal1_pressed():
	get_node("/root/global").goto_scene("res://scenes/GameOver.tscn")
