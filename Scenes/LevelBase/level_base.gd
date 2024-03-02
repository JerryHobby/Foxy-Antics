extends Node2D
@onready var player_cam = $PlayerCam
@onready var player = $Player



# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_boss_killed.connect(on_boss_killed)
	pass # Replace with function body.


func on_boss_killed(_p) -> void:
	#exit_barrier.queue_free()
	pass


func _physics_process(_delta):
	player_cam.position = player.position



