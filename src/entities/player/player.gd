extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $Anim

var facing_right := true

enum states {
	IDLE,
	WALK,
	RUN,
	TURN,
	HURT,
	DEATH
}
var current_state = states.IDLE

@export var movement_speed := 50
var direction : Vector2

func _process(delta: float) -> void:
	direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
	if direction != Vector2.ZERO:
		current_state = states.WALK
	else:
		current_state = states.IDLE
	
	match current_state:
		states.IDLE:
			anim.play("idle_right")
		states.WALK:
			anim.play("walk_right")


func _physics_process(delta: float) -> void:
	velocity = direction * movement_speed
	move_and_slide()
