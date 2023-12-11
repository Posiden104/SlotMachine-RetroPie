extends Node2D

class_name game_manager

signal spinning
signal stopping
signal stopped

signal win

enum spinner_state {
	STOPPED,
	SPINNING,
	STOPPING
}

enum win_type {
	NONE,
	NORMAL,
	BIG
}

var state
var l_stop: bool
var m_stop: bool
var r_stop: bool
var l_idx: int
var m_idx: int
var r_idx: int

var spin_time: float = 2.0
var pull_timer: float

var bet: int = 1

var credit_image_limits: Array = [6, 11, 13]

# 1c min
var bell = preload("res://images/bell.png")
var cherry = preload("res://images/cherries.png")
var clover = preload("res://images/clover.png")
var horseshoe = preload("res://images/horseshoe.png")
var heart = preload("res://images/heart.png")
var lemon = preload("res://images/lemon.png")
var melon = preload("res://images/melon.png")

# 2c min
var bar1 = preload("res://images/Bar1.png")
var bar2= preload("res://images/Bar2.png")
var bar3 = preload("res://images/Bar3.png")
var lucky7 = preload("res://images/Lucky7.png")
var heart_outline = preload("res://images/heart_outline.png")

# 3c min
var heart_rainbow = preload("res://images/heart_rainbow.png")
var lucky7_rainbow = preload("res://images/Lucky7_rainbow.png")

var images: Array

var fixed: bool
var locked: bool

var pulls: float = 0
var wins: float = 0
var win_target: float = 0.25

func _ready():
	images.push_back(bell)
	images.push_back(cherry)
	images.push_back(clover)
	images.push_back(horseshoe)
	images.push_back(heart)
	images.push_back(lemon)
	images.push_back(melon)
	
	images.push_back(bar1)
	images.push_back(bar2)
	images.push_back(bar3)
	images.push_back(lucky7)
	images.push_back(heart_outline)
	
	images.push_back(heart_rainbow)
	images.push_back(lucky7_rainbow)
	
	state = spinner_state.STOPPED
	
	SignalBus.connect("bet_changed", self, "bet_changed")


func _physics_process(delta):
	if Input.is_action_just_pressed("fixit") and state == spinner_state.STOPPED and not locked:
		fixed = true
		start_spin(fixed)
	elif Input.is_action_pressed("select") and Input.is_action_pressed("spin") and state == spinner_state.STOPPED and not locked:
		fixed = true
		start_spin(fixed)
	elif Input.is_action_just_pressed("spin") and state == spinner_state.STOPPED and not locked:
		fixed = false
		start_spin(fixed)
	
	if state == spinner_state.SPINNING:
		pull_timer += delta
		if pull_timer > spin_time:
			state = spinner_state.STOPPING
			emit_signal("stopping")
			pull_timer = 0


func lock_wheel(lock: bool):
	locked = lock


func bet_changed():
	bet = bet + 1
	if bet > 3:
		bet = 1
	SignalBus.emit_signal("bet_updated", bet)


func get_win_percent():
	if pulls == 0:
		return 0
	return wins / pulls


func should_fix():
	return get_win_percent() < win_target


func start_spin(fix: bool):
		state = spinner_state.SPINNING
		l_stop = false
		m_stop = false
		r_stop = false
		if fix:
			emit_signal("spinning", fix, 13)
		else:
			emit_signal("spinning", should_fix(), randi() % credit_image_limits[bet - 1])
		spin_time = rand_range(2.0, 4.0)
		pulls += 1


func stop():
	state = spinner_state.STOPPED
	check_win()


func check_win():
	if l_idx == m_idx and m_idx == r_idx:
		wins += 1
		emit_signal("stopped")
		if l_idx == 13:
			emit_signal("win", win_type.BIG)
		else:
			emit_signal("win", win_type.NORMAL)
	emit_signal("stopped")



func check_stop():
	if l_stop and m_stop and r_stop:
		stop()


func spinner_stop(spinner: String, img_idx: int):
	if spinner.to_lower() == "left":
		l_stop = true
		l_idx = img_idx
	if spinner.to_lower() == "middle":
		m_stop = true
		m_idx = img_idx
	if spinner.to_lower() == "right":
		r_stop = true
		r_idx = img_idx
	
	check_stop()


func pick_image_index(_spinner: String, is_final: bool) -> int:
	var image_idx = randi() % credit_image_limits[bet - 1]
	return image_idx
