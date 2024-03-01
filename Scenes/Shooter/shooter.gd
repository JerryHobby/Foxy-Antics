extends Node2D

@onready var sound = $Sound
@onready var shooter_timer = $ShooterTimer

@export var speed = 50.0
@export var life_span = 10.0
@export var bullet_key:ObjectMaker.BULLET_KEY
@export var shoot_delay:float = 0.7


var _can_shoot:bool = true


func _ready():
	shooter_timer.wait_time = shoot_delay

func shoot(direction:Vector2) -> void:
	if _can_shoot == false:
		return
	
	_can_shoot = false
	SoundManager.play_clip(sound, SoundManager.SOUND_LASER)
	ObjectMaker.create_bullet(
		speed,
		direction,
		global_position,
		life_span,
		bullet_key
	)
	shooter_timer.start()



func _on_shooter_timer_timeout():
	_can_shoot = true
