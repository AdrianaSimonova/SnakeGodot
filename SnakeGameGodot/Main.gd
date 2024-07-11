extends Node2D

var berry_scene = preload("res://Berry.tscn")
var berry
var score = 0

func spawn_berry():
	if berry:
		berry.queue_free()
	berry = berry_scene.instance()
	add_child(berry)

	
func eat_berry():
	score += 1
	$Snake.grow()
	move_berry()

func move_berry():
	berry.randomize_position()
	berry.reset_collision()


func _on_Snake_endGame():
	$Snake.hide()
	berry.hide()
	$HUD.show_game_over(score)


func newGame():
	score = 0
	spawn_berry() 
	berry.show()
	$Snake.show()
	$Snake.start($StartPosition.position)
	$HUD.hideMessage()
	print("START")


func _on_Snake_hit():
		eat_berry()
		
