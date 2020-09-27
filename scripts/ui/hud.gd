extends CanvasLayer


func _process(delta):
	var score = calc_score()
	Score.score = score
	$Score.text = "Score: " + str(score)
	
func calc_score():
	var cam = get_parent().get_node("Schaf")
	return int(cam.position.x / 10)
