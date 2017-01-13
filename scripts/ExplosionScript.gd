extends Node2D


onready var anim = get_node("AnimationPlayerPlayer")
	
func _ready():
	set_process(true)
	
func blowItUp():
	anim.play("New Anim")

func stopBlowing():
	anim.stop()
func is_playing():
	return anim.is_playing()

func is_active():
	return anim.is_active()

func stop():
	anim.stop()