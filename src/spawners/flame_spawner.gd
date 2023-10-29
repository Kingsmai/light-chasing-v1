extends Node

@export var level_tilemap: TileMap
@export var maximum_spawn_count := 20
@onready var character_light_flame: PackedScene = preload("res://src/entities/collectibles/collectibles.tscn")


func _on_spawn_timer_timeout() -> void:
	#  上限 20
	var flames_in_scene = get_tree().get_nodes_in_group("Fire")
	if len(flames_in_scene) >= maximum_spawn_count:
		return
	var flame : Node2D = character_light_flame.instantiate()
	flame.position = _get_random_spawn_pos()
	add_child(flame)
	pass


func _get_random_spawn_pos() -> Vector2:
	var tilemap_size = level_tilemap.get_used_rect().size
	var pos = Vector2(
		randi_range(2, tilemap_size.x - 2),
		randi_range(2, tilemap_size.y - 2)
	) * 16
	return pos
