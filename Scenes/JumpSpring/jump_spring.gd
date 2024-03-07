extends Area2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var sound = $sound

@export var jump_velocity:Vector2 = Vector2(-2000, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(_area):
	SignalManager.on_jump_spring.emit(jump_velocity)
	SoundManager.play_clip(sound, SoundManager.SOUND_BOING)
	animated_sprite_2d.play()
