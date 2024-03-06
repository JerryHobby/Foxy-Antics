extends CanvasLayer
@onready var audio_stream_player = $AudioStreamPlayer
@onready var label_high_score = $VBoxContainer/LabelHighScore


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	ScoreManager.reset_score()
	var score = str(ScoreManager.get_highscore()).lpad(5, "0")
	label_high_score.text = "High Score: %s" % score
	
	if GameManager.music:
		audio_stream_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("start"):
		GameManager.load_next_level_scene()

	if Input.is_action_just_pressed("escape"):
		ScoreManager.reset_highscore()
		label_high_score.text = "High Score: %s" % ScoreManager.get_highscore()	
