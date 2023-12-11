extends Node2D


#onready var input_label = $"../Input Label"
#onready var raw_label = $"../Raw Label"
#onready var axis_label = $"../Axis Label"
#
#var label_format = "Button Pressed: %s"
#var raw_format = "Raw Pressed: %s"
#var axis_format = "Axis Pressed: %f"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
#	var joys = Input.get_connected_joypads()
#	var lbl = "Connected Joys: \n"
#	for i in joys:
#		lbl = lbl + "%d\n" % i
#	axis_label.text = lbl

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("select") and Input.is_action_pressed("start"):
		get_tree().quit()
		
#	for i in range(2,16):
#		var btn_name = "button%d" % i
#		if Input.is_action_just_pressed(btn_name):
#			input_label.text = label_format % btn_name
#	if Input.is_action_just_pressed("spin"):
#		input_label.text = label_format % "button0"
#	if Input.is_action_just_pressed("bet"):
#		input_label.text = label_format % "button1"
	
#	for i in range(0, 80):
#		if Input.is_joy_button_pressed(0, i):
#			raw_label.text = raw_format % i
#		if Input.get_joy_axis(0, i):
#			axis_label.text = axis_format %i

func _on_BetButton_pressed():
	SignalBus.emit_signal("bet_changed")
