extends Node2D

class_name Spinner

signal stopped

export var reel: Resource
export var seconds_for_each_image: float
export var slow_target: float
export var slow_speed: float
export var pos: String
export var show_slowdown: bool
export var volume_scale: float

enum spinner_state {
	STOPPED,
	SPINNING,
	STOPPING
}

var state

var spin_timer: float
var current_image_time: float
var pull_timer: float
var slowdown_steps: int

var fix: bool
var fix_idx: int

onready var image = $Image
var image_idx: int

onready var sound_player:AudioStreamPlayer2D = $SoundPlayer
var spin_sound = preload("res://sounds/slot_spin_001.wav")
var stop_sound = preload("res://sounds/slots_spin_stop_001.wav")

var initial_db: float = -20
var current_db: float


# Called when the node enters the scene tree for the first time.
func _ready():
	$"%GameManager".connect("spinning", self, "spin")
	$"%GameManager".connect("stopping", self, "stopping")
	
	current_image_time = seconds_for_each_image

func spin(_fix: bool, idx: int):
	current_db = initial_db
	sound_player.volume_db = current_db
	state = spinner_state.SPINNING
	slowdown_steps = 0
	fix = _fix
	fix_idx = idx
	sound_player.stop()
	sound_player.stream = spin_sound

func stopping():
	state = spinner_state.STOPPING

func stop():
	if fix:
		image.texture = $"%GameManager".images[fix_idx]
		image_idx = fix_idx
	else:
		image.texture = pick_image(true)
	state = spinner_state.STOPPED
#	print("%s, %d" % [pos, slowdown_steps])
	emit_signal("stopped")
	$"%GameManager".spinner_stop(pos, image_idx)
	sound_player.volume_db = initial_db
	sound_player.stop()
	sound_player.stream = stop_sound
	sound_player.play()

func _physics_process(delta):
	if state == spinner_state.STOPPING:
		slowdown_steps += 1
		current_image_time = current_image_time * slow_speed
		current_db -= current_image_time * volume_scale
		sound_player.volume_db = current_db
		if current_image_time > slow_target:
			state = spinner_state.STOPPED
			current_image_time = seconds_for_each_image
			stop()
	
	if state == spinner_state.SPINNING or state == spinner_state.STOPPING:
		spin_timer += delta
		if spin_timer >= current_image_time:
			sound_player.play()
			image.texture = pick_image(false)
			spin_timer = 0.0


func pick_image(is_final: bool):
	image_idx = $"%GameManager".pick_image_index(pos, is_final)
	return $"%GameManager".images[image_idx]
