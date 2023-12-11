extends Node2D


onready var bet_label = $BetLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("bet_updated", self, "bet_updated")

func bet_updated(bet):
	bet_label.text = "Bet: %d" % bet
