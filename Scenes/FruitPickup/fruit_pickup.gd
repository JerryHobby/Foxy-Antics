extends Area2D
@onready var animated_sprite_2d = $AnimatedSprite2D

const FRUITS:Array = [
	"banana",
	"cherries",
	"kiwi",
	"melon"
]

const GRAVITY:float = 200.0
const JUMP:float = -100.0
const POINTS:int = ScoreManager.FRUIT_POINTS

var _start_y:float
var _speed_y:float = JUMP
var _stopped:bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	_start_y = global_position.y
	animated_sprite_2d.play(FRUITS.pick_random())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _stopped == true:
		return
		
	position.y += _speed_y * delta
	_speed_y += GRAVITY * delta
	
	if global_position.y > _start_y:
		_stopped = true


func kill_me() -> void:
	set_process(false)
	hide()
	queue_free()


func _on_area_entered(_area):
	SignalManager.on_pickup_hit.emit(POINTS)
	kill_me()


func _on_life_timer_timeout():
	kill_me()
