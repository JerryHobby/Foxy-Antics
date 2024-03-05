extends Node2D
@onready var player_cam = $PlayerCam
@onready var player = $Player
@onready var exit_barrier = $ExitBarrier
@onready var music = $Music


# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.time_scale = 1
	
	SignalManager.on_boss_killed.connect(on_boss_killed)
	if GameManager.music:
		music.play()


func _process(_delta):
	player_cam.position = player.position
	if Input.is_action_just_pressed("escape"):
		GameManager.load_next_level_scene()



func on_boss_killed(_p) -> void:
	exit_barrier.queue_free()
	pass




