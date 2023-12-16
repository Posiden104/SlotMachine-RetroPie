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


func get_image(i: int) -> Texture:
	for e in spinner_entries:
		if e.id == i:
			return e.image
	return null

#
#func get_id(i: int) -> int:
#	return spinner_entries[i].id
