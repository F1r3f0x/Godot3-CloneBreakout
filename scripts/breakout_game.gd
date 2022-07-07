extends Node2D


onready var node_level := $Level
onready var node_popup_timer := $UI/Popup/PopupTimer
onready var lbl_bricks := $UI/InfoCnt/Bricks
onready var lbl_score := $UI/InfoCnt/Score
onready var lbl_lives := $UI/InfoCnt/Lives


var format_bricks := 'Bricks: %d / %d'
var format_score := 'Score: %d'
var format_lives := 'Lives: %d'

var initial_bricks := 0
var bricks := 0

var score := 0

var lives:= 3

var popup = false

func show_popup(text: String, seconds: float):
	$UI/Popup/PanelContainer/PopupLabel.text = text
	$UI/Popup.visible = true
	yield(get_tree().create_timer(seconds), "timeout")
	$UI/Popup.visible = false


func _ready():
	initial_bricks = node_level.get_used_cells().size()  # Get the brick count. (Might need to change if I add other entities)
	bricks = initial_bricks
	
	show_popup('Pinga', 2)


func _physics_process(_delta):
	#Update counters
	bricks = node_level.get_used_cells().size()

	# Update labels
	lbl_bricks.text = format_bricks % [bricks, initial_bricks]
	lbl_score.text = format_score % score
	lbl_lives.text = format_lives % lives
	
	
