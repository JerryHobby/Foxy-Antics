extends Area2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var sound = $Sound

const FRUITS:Array = [
	"banana",
	"cherries",
	"kiwi",
	"melon"
]

const POINTS:int = ScoreManager.FRUIT_POINTS


# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play(FRUITS.pick_random())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func kill_me() -> void:
	visible = false
	sound.finished.connect(queue_free)


func _on_area_entered(_area):
	SignalManager.on_pickup_hit.emit(POINTS)
	SoundManager.play_clip(sound, SoundManager.SOUND_PICKUP)
	kill_me()
