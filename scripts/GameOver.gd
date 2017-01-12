func _on_BackToMenu_pressed():
	get_node("/root/global").goto_scene("res://scenes/MainMenu.tscn")
	
func _on_TryAgain_pressed():
	get_node("/root/global").goto_scene("res://scenes/Gameplay.tscn")