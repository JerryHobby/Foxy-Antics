extends CanvasLayer
@onready var audio_stream_player = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.time_scale = 1
	ScoreManager.reset_score()
	
	if GameManager.music:
		audio_stream_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("jump"):
		GameManager.load_next_level_scene()

