extends Resource

class_name PayTable

export(Array, String) var id_payout
export var use_wild: bool
export var wild_id: int

var table: Array

var table_entry = preload("res://resources/pay_tables/pay_table_entry.gd")

func _setup_local_to_scene():
	for entry in id_payout:
		var t = table_entry.new(entry, wild_id)
		table.push_back(t)

func get_max_payout(l: int, m: int, r: int) -> int:
	var win = 0
	for t in table:
		var pte = t as PayTableEntry
		var w = pte.get_win(l, m, r)
		if w > win:
			win = w
	
	return win
