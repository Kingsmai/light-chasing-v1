extends Node

@export var level_tilemap: TileMap
@export var maximum_spawn_count := 20
var energy_light:= [
	preload("res://src/entities/collectibles/energies/red_energy.tscn"),
	preload("res://src/entities/collectibles/energies/green_energy.tscn"),
	preload("res://src/entities/collectibles/energies/blue_energy.tscn")
]


func _on_energy_spawn_timer_timeout() -> void:
	#  上限 20
	var flames_in_scene = get_tree().get_nodes_in_group("Energy")
	if len(flames_in_scene) >= maximum_spawn_count:
		return
	var flame = energy_light.pick_random().instantiate()
	flame.position = _get_random_spawn_pos()
	add_child(flame)


func _get_random_spawn_pos() -> Vector2:
	var tilemap_size = level_tilemap.get_used_rect().size
	var pos = Vector2(
		randi_range(2, tilemap_size.x - 2),
		randi_range(2, tilemap_size.y - 2)
	) * 16
	return pos
