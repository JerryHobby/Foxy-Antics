extends Area2D
@onready var animation_tree = $AnimationTree

const TRIGGER_CONDITION: String = "parameters/conditions/on_trigger"


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_boss_killed.connect(on_boss_killed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	queue_free()
	print("LEVEL COMPLETE")


func on_boss_killed(_p) -> void:
	animation_tree[TRIGGER_CONDITION] = true
	monitoring = true
	
