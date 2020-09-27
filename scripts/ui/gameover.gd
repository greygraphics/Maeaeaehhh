extends Node2D


export var sound_list : Resource


func _ready():
	$Username.text = Score.username
	var score = Score.score
	$Score.text = "Your Score: " + str(score)
	var sound := sound_list.sounds[randi() % sound_list.sounds.size()] as AudioStream
	$AudioStreamPlayer.stream = sound
	$AudioStreamPlayer.play()

	
func play_again():
	Score.score = 0
	get_tree().change_scene("res://scenes/world.tscn")

func submit_button():
	var username = $Username.text
	Score.username = username
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	# Ugly code dublication, but I dont know how to do else because yield
	var url = ("https://scores.tmbe.me/score?game=" + "Määäääh".percent_encode() +
		"&player=" + username.percent_encode() +
		"&score=" + str(Score.score).percent_encode())
	
	if http_request.request(url, [], true, HTTPClient.METHOD_POST) != OK:
		print("Sending highscore failed")
		return -1
	var response = yield(http_request, "request_completed")
	if response[1] != 200:
		print("Sending highscore returned " + str(response[1]))
		return -1
	remove_child(http_request)
	
	var position = JSON.parse(response[3].get_string_from_utf8()).result["position"]
	
	$Username.hide()
	$UsernameLabel.hide()
	$UsernameSubmit.hide()
	$Place.show()
	$Place.text = "Rank: " + str(position)
	
	add_child(http_request)
	var get_url = ("https://scores.tmbe.me/score?game=" + "Määäääh".percent_encode())
	if http_request.request(url, [], true, HTTPClient.METHOD_GET) != OK:
		print("Getting highscore failed")
		return -1
	var response2 = yield(http_request, "request_completed")
	if response2[1] != 200:
		print("Getting highscore returned " + str(response2[1]))
		return -1
	remove_child(http_request)
	
	var data = JSON.parse(response2[3].get_string_from_utf8()).result
	print(data)
	var out_str = ""
	for entry in data:
		out_str += entry["player"] + ": " + str(entry["score"]) + "\n"
	
	$Others.show()
	$Highscores.show()
	$Highscores.text = out_str


func _on_Username_text_entered(new_text: String) -> void:
	submit_button()
