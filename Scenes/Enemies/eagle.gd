extends EnemyBase

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var player_detector = $PlayerDetector
@onready var direction_timer = $DirectionTimer

const FLY_SPEED: Vector2 = Vector2(35, 15)

var _fly_direction:Vector2 = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = _fly_direction
	move_and_slide()


func set_and_flip() -> void:
	var x_dir = sign(_player_ref.global_position.x - global_position.x) 
	if x_dir > 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	
	_fly_direction = Vector2(x_dir, 1) * FLY_SPEED


func fly_to_player() -> void:
	set_and_flip()
	direction_timer.start()



func _on_visible_on_screen_notifier_2d_screen_entered():
	animated_sprite_2d.play("fly")
	fly_to_player()


func _on_visible_on_screen_notifier_2d_screen_exited():
	animated_sprite_2d.stop()


func _on_direction_timer_timeout():
	fly_to_player()
