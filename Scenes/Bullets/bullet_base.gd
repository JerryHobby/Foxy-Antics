extends Area2D

var _direction:Vector2 = Vector2.RIGHT
var _life_span:float = 20.0
var _life_time:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	check_expired(_delta)
	position += _direction * _delta


func setup(dir:Vector2, life_span:float, speed:float) -> void:
	_direction = dir.normalized() * speed
	_life_span = life_span


func check_expired(_delta:float) -> void:
	_life_time += _delta
	if _life_time > _life_span:
		queue_free()
	

func _on_area_entered(_area):
	queue_free()
	
