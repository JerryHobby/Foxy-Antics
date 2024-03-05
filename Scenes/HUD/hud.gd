extends Control
@onready var label_level = $MCScoreBar/HBoxLevel/LabelLevel
@onready var color_rect = $ColorRect
@onready var vb_level_complete = $ColorRect/VB_LevelComplete
@onready var vb_game_over = $ColorRect/VB_GameOver
@onready var h_box_hearts = $MCScoreBar/HBoxHearts
@onready var score_label = $MCScoreBar/HBoxScore/ScoreLabel
@onready var label_god_mode = $MCScoreBar/HBoxScore/LabelGodMode


var _hearts:Array

# Called when the node enters the scene tree for the first time.
func _ready():
	label_level.text = "Level %s" % GameManager.get_current_level()
	SignalManager.on_level_complete.connect(on_level_complete)
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_player_hit.connect(on_player_hit)
	SignalManager.on_score_updated.connect(on_score_updated)
	SignalManager.on_god_mode.connect(on_god_mode)
	_hearts = h_box_hearts.get_children()
	on_score_updated()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if vb_level_complete.visible == true:
		if Input.is_action_just_pressed("jump"):
			hide_hud()
			GameManager.load_next_level_scene()

	if vb_game_over.visible == true:
		if Input.is_action_just_pressed("jump"):
			hide_hud()
			GameManager.load_main_scene()

func on_score_updated() -> void:
	score_label.text = str(ScoreManager.get_score()).lpad(5, "0")


func on_player_hit(lives):
	for life in GameManager.TOTAL_LIVES:
		_hearts[life].visible = lives > life


func show_hud():
	get_tree().paused = true
	color_rect.show()


func on_god_mode(mode:bool) -> void:
	label_god_mode.visible = mode


func hide_hud():
	vb_level_complete.hide()
	vb_game_over.hide()
	color_rect.hide()


func on_level_complete():
	if GameManager.get_current_level() == GameManager.TOTAL_LEVELS:
		SignalManager.on_game_over.emit()
	else:
		vb_level_complete.show()
		show_hud()


func on_game_over():
	vb_game_over.show()
	show_hud()
