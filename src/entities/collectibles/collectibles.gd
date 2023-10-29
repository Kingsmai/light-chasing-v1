extends Area2D
class_name Collectibles

@onready var point_light_2d: PointLight2D = $PointLight2D

var is_eaten = false

func _process(delta: float) -> void:
	if is_eaten:
		point_light_2d.texture_scale -= delta * 0.25
		scale -= Vector2.ONE * delta
	if scale <= Vector2.ZERO:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if is_eaten:
		return
	if body is Player:
		body.grow_light(point_light_2d.texture_scale)
		is_eaten = true
