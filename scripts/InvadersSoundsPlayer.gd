extends SamplePlayer

func _ready():
	pass
func invaderHit():
	play("invader_hit")
	
func invader1():
	play("invader_sound_1")
	
func invader2():
	play("invader_sound_2")
	
func invader3():
	play("invader_sound_3")
	
func invader4():
	play("invader_sound_4")
	
func shipExplosion():
	play("player_explosion")
	
func shot():
	play("shot")
	
func specialInvaderHit():
	play("ufo_hit")
	
func spcecialInvaderMove():
	play("ufo_move")
	
func bunker_hit():
	play("bunker_hit")