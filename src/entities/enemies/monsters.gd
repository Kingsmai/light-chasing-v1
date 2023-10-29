extends CharacterBody2D
class_name Monsters

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_detector_collider: CollisionShape2D = $PlayerDetector/PlayerDetectorCollider
@onready var cooldown_timer: Timer = $CooldownTimer

@export_flags("Red", "Green", "Blue") var weakness_color = 0
var drop_fires := [
	preload("res://src/entities/collectibles/energies/red_energy.tscn"),
	preload("res://src/entities/collectibles/energies/green_energy.tscn"),
	preload("res://src/entities/collectibles/energies/blue_energy.tscn")
]

enum state {
	SKULL, # For skeleton
	SPAWNING, # For skeleton
	SLEEP, # For ghost
	WAKE, # For Ghost
	IDLE,
	CHASING,
	COOLDOWN,
	WALK,
	RUN,
	TURN,
	HURT,
	DEATH
}
var current_state = state.IDLE

var damage : float = 1.0
var health : float = 1.5
var is_dead := false
# 屎山代码
var reward_popped = false

var movement_speed = 50
var target : Node2D

func _process(delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		anim.play("death")
		await anim.animation_finished
		# TODO: Rewards
		if !reward_popped:
			# 死了之后掉火
			var energy_fire = drop_fires.pick_random().instantiate()
			energy_fire.position = position
			get_parent().add_child(energy_fire)
			reward_popped = true
		queue_free()
		return
	
	if current_state == state.COOLDOWN:
		anim.play("idle")
		velocity = Vector2.ZERO
		return
	
	if target != null:
		var direction = position.direction_to(target.position)
		# Chase player
		velocity = direction * movement_speed
	else:
		velocity = Vector2.ZERO
	
	anim.flip_h = velocity.x < 0 if velocity.x != 0 else velocity.x
	
	match current_state:
		state.IDLE:
			anim.play("idle")
		state.WALK:
			anim.play("walk")
		state.RUN:
			anim.play("run")


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player and current_state == state.IDLE:
		current_state = state.RUN
		target = body


func _on_player_detector_body_exited(body: Node2D) -> void:
	if body is Player:
		current_state = state.IDLE
		target = null


func _on_player_collider_body_entered(body: Node2D) -> void:
	if current_state == state.COOLDOWN:
		return
	if body is Player:
		body.take_damage(damage)
		current_state = state.COOLDOWN
		cooldown_timer.start()


func _on_cooldown_timer_timeout() -> void:
	current_state = state.IDLE


func take_damage(amount:float, red_light:bool, green_light:bool, blue_light:bool):
	match weakness_color:
		0:
			health -= amount
		1:
			if red_light:
				health -= amount
		2:
			if green_light:
				health -= amount
		4:
			if blue_light:
				health -= amount
		3:
			if red_light and green_light:
				health -= amount
		5:
			if red_light and blue_light:
				health -= amount
		6:
			if blue_light and green_light:
				health -= amount
		7:
			if red_light and green_light and blue_light:
				health -= amount
	if health <= 0:
		# Drop fire
		is_dead = true
