extends Resource

class_name PayTableEntry

var l: int = 0
var m: int = 0
var r: int = 0
var payout: int = 0
var wild: int = 0

func _init(lmrp: String, _wild: int):
	var spl = lmrp.split(",")
	l = int(spl[0])
	m = int(spl[1])
	r = int(spl[2])
	payout = int(spl[3])
	wild = _wild
	
#	print("%d - %d - %d: pays %d with wild %d" %[l, m, r, payout, wild])

func get_win(_l,_m,_r) -> int:
#	print("%d-%d, %d-%d, %d-%d, wild: %d" % [_l, l, _m, m, _r, r, wild])
	if \
	(l == _l or _l == wild) \
	and \
	(m == _m or _m == wild) \
	and \
	(r == _r or _r == wild):
		return payout
	return 0
