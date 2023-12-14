extends Resource

class_name Reel

export(Array, Resource) var spinner_entries

var idx: int = 0

func get_random_entry() -> int:
	return spinner_entries[randi() % spinner_entries.size()].id
	

func get_next_image() -> Texture:
	var t = spinner_entries[idx].image
	idx += 1
	return t
