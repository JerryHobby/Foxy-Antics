extends Node


var _score:int = 0
const LEVEL_COMPLETE_POINTS = 100
const ENEMY_POINTS = 10
const BOSS_POINTS = 50
const FRUIT_POINTS = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_boss_killed.connect(on_boss_killed)
	SignalManager.on_enemy_hit.connect(on_enemy_hit)
	SignalManager.on_level_complete.connect(on_level_complete)
	SignalManager.on_pickup_hit.connect(on_pickup_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_boss_killed(points) -> void:
	_score += points

func on_enemy_hit(points, _p) -> void:
	_score += points

func on_level_complete() -> void:
	_score += LEVEL_COMPLETE_POINTS


func on_pickup_hit(points) -> void:
	_score += points


func get_score() -> int:
	return _score


func reset_score() -> void:
	_score = 0
