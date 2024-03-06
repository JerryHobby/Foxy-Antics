extends Node

const HS_FILE:String = "user://scores.dat"
const HS_KEY:String = "highscore"

var _score:int = 0
var _highscore:int = 0

var _disable_high_score:bool = false

const LEVEL_COMPLETE_POINTS = 20 # * level * lives
const ENEMY_POINTS = 10
const BOSS_POINTS = 25
const FRUIT_POINTS = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_boss_killed.connect(on_boss_killed)
	SignalManager.on_enemy_hit.connect(on_enemy_hit)
	SignalManager.on_level_complete.connect(on_level_complete)
	SignalManager.on_pickup_hit.connect(on_pickup_hit)
	SignalManager.on_god_mode.connect(on_god_mode)
	load_highscore()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func on_god_mode(enable:bool):
	if _score == 0 and enable == false:
		print("Enabling High Score")
		_disable_high_score = false
	elif enable == true:
		print("Disabling High Score")
		_disable_high_score = true
	return


func load_highscore() -> void:
	if FileAccess.file_exists(HS_FILE) == false:
		return
	
	var file = FileAccess.open(HS_FILE, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	if HS_KEY in data:
		_highscore = data[HS_KEY]


func save_highscore(score:int) -> void:
	if _disable_high_score:
		print("Cannot save high: cheats enabled")
		return
	
	if score <= _highscore:
		return
	
	_highscore = score
	print("New high score: ", _highscore)
	
	var file = FileAccess.open(HS_FILE, FileAccess.WRITE)
	file.store_string(JSON.stringify({
		HS_KEY: _highscore
	}))
	file.close()


func get_highscore() -> int:
	return _highscore


func reset_highscore() -> void:
	_highscore = -1
	save_highscore(0)


func set_score(points:int) -> void:
	if _score == 0 and _disable_high_score:
		_disable_high_score = false
		print("Re-enabling High Score")
		
	_score += points * GameManager.get_current_level()
	SignalManager.on_score_updated.emit()
	save_highscore(_score)


func on_boss_killed(points) -> void:
	set_score(points)


func on_enemy_hit(points, _p) -> void:
	set_score(points)


func on_pickup_hit(points) -> void:
	set_score(points)
	

func on_level_complete() -> void:
	set_score(LEVEL_COMPLETE_POINTS * GameManager.get_lives_remaining())


func get_score() -> int:
	return _score


func reset_score() -> void:
	_score = 0
