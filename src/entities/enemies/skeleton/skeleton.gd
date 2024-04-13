extends Monsters

@onready var spawn_sound: AudioStreamPlayer = $SpawnSound


func _ready() -> void:
	current_state = state.SKULL


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		if current_state == state.SKULL:
			# Spawn
			current_state = state.SPAWNING
			anim.play("spawn")
			spawn_sound.play()
			await anim.animation_finished
			# Chase player if in radius after spawn
			if body.position.distance_to(position) <= player_detector_collider.shape.radius:
				current_state = state.RUN
				target = body
			else:
				current_state = state.IDLE
		elif current_state == state.IDLE:
			current_state = state.RUN
			target = body
