extends Node

var current_scene = null
var points = 0
var hiscore = 0
var shipsLeft = 3
var menuMusic
var mus
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )

	mus = get_node("/root/ufscpl")

	menuMusic = get_node("/root/MenuMusic")
	menuMusic.play()
	
func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function from the running scene.
	# Deleting the current scene at this point might be
	# a bad idea, because it may be inside of a callback or function of it.
	# The worst case will be a crash or unexpected behavior.
	# The way around this is deferring the load to a later time, when
	# it is ensured that no code from the current scene is running:
	
	
	
	call_deferred("_deffered_goto_scene", path)
func checkIfYouAreHiScore():
	if(points > hiscore):
		hiscore = points
func subtractShip():
	shipsLeft = shipsLeft - 1
func addShip():
	shipsLeft = shipsLeft + 1
func checkIfYouDied():
	return shipsLeft == 0
func _deffered_goto_scene(path):
	# Immediately free the current scene,
	# there is no risk here.
	current_scene.free()
	
	# Load new scene
	var s = ResourceLoader.load(path)

	# Instance the new scene
	current_scene = s.instance()
	
	# Add it to the active scene, as child of root
	get_tree().get_root().add_child(current_scene)
	
	# optional, to make it compatible with the SceneTree.change_scene() API
	get_tree().set_current_scene( current_scene )
	


func playMenuMusic():