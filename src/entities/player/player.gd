extends CharacterBody2D
class_name Player

signal game_over
signal win

@onready var anim: AnimatedSprite2D = $Anim
@onready var hand: Node2D = %Hand
@onready var camera_2d: Camera2D = $Camera2D

# 自身的光
@onready var point_light_2d: PointLight2D = $PointLight2D
var light_prepare_to_add = 0.0

# 能量槽
@onready var red_gauge: HBoxContainer = $HUD/Gauges/RedGauge/HBoxContainer
@onready var green_gauge: HBoxContainer = $HUD/Gauges/GreenGauge/HBoxContainer
@onready var blue_gauge: HBoxContainer = $HUD/Gauges/BlueGauge/HBoxContainer

@onready var red_torch_light: PointLight2D = %RedTorchLight
@onready var green_torch_light: PointLight2D = %GreenTorchLight
@onready var blue_torch_light: PointLight2D = %BlueTorchLight
@onready var torch_damage: CollisionShape2D = $Hand/TorchDamage/CollisionShape2D

@onready var timer_label: Label = $HUD/TimerLabel

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

var health_empty = preload("res://resources/atlas_textures/health/health_empty.tres")
var health_half = preload("res://resources/atlas_textures/health/health_half.tres")
var health_full = preload("res://resources/atlas_textures/health/health_full.tres")
var health : float = 0.0:
	set(val):
		health = val
		var health_icons = $HUD/Gauges/HealthBar.get_children()
		for health_icon in health_icons:
			health_icon.texture = health_empty
		for i in int(health):
			health_icons[i].texture = health_full
		if health <= 0:
			game_over.emit()

@export var movement_speed := 100
var direction : Vector2
var look_direction : Vector2

var red_energy : int = 0:
	set(val):
		var energy_blocks = red_gauge.get_children()
		for energy_block in energy_blocks:
			energy_block.visible = false
		if val > 5:
			val = 5
		red_energy = val
		for i in val:
			energy_blocks[i].visible = true
var green_energy : int = 0:
	set(val):
		var energy_blocks = green_gauge.get_children()
		for energy_block in energy_blocks:
			energy_block.visible = false
		if val > 5:
			val = 5
		green_energy = val
		for i in val:
			energy_blocks[i].visible = true
var blue_energy : int = 0:
	set(val):
		var energy_blocks = blue_gauge.get_children()
		for energy_block in energy_blocks:
			energy_block.visible = false
		if val > 5:
			val = 5
		blue_energy = val
		for i in val:
			energy_blocks[i].visible = true

var red_light_timer := 0.0
var green_light_timer := 0.0
var blue_light_timer := 0.0
var light_is_on = false
var target_inside_light := []
var light_damage = 1 # 1 damage per second

# 屎山代码：时间倒计时
var timer = 300: # seconds
	set(val):
		timer = val
		var min = val / 60
		var sec = val % 60
		var time_str = str(min).pad_zeros(2) + ":" + str(sec).pad_zeros(2)
		timer_label.text = time_str

func _ready() -> void:
	health = 3
	red_energy = 2
	green_energy = 2
	blue_energy = 2


func _process(delta: float) -> void:
	
	direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	
	look_direction = camera_2d.get_global_mouse_position() - position
	hand.rotation = look_direction.angle()
	
	facing_right = look_direction.x > 0
	anim.flip_h = !facing_right
	
	if direction != Vector2.ZERO:
		current_state = states.WALK
	else:
		current_state = states.IDLE
	
	match current_state:
		states.IDLE:
			anim.play("idle_right")
		states.WALK:
			anim.play("walk_right")
	
	velocity = direction * movement_speed
	
	# Open the light
	# TODO: Just a meme to play switch on and off, will remove later
	if Input.is_action_just_pressed("red_light") and red_energy > 0:
		red_energy -= 1
		red_light_timer = 5.5
	if Input.is_action_just_pressed("green_light") and green_energy > 0:
		green_energy -= 1
		green_light_timer = 5.5
	if Input.is_action_just_pressed("blue_light") and blue_energy > 0:
		blue_energy -= 1
		blue_light_timer = 5.5
	
	# Light will switch off overtime
	if red_light_timer > 0:
		red_torch_light.visible = true
		red_torch_light.energy = clampf(red_light_timer, 0, 1)
		red_light_timer -= delta
	else:
		red_torch_light.visible = false
	if green_light_timer > 0:
		green_torch_light.visible = true
		green_torch_light.energy = clampf(green_light_timer, 0, 1)
		green_light_timer -= delta
	else:
		green_torch_light.visible = false
	if blue_light_timer > 0:
		blue_torch_light.visible = true
		blue_torch_light.energy = clampf(blue_light_timer, 0, 1)
		blue_light_timer -= delta
	else:
		blue_torch_light.visible = false
	
	light_is_on = red_torch_light.visible or green_torch_light.visible or blue_torch_light.visible
	torch_damage.disabled = !light_is_on
	
	# Body light increase from prepared
	if light_prepare_to_add >= 0:
		point_light_2d.texture_scale += delta # 屎山代码：增强光吸收
#		point_light_2d.energy += delta
		light_prepare_to_add -= delta
	
	# Body light decrease overtime
	point_light_2d.texture_scale = clamp(point_light_2d.texture_scale - 0.025 * delta, 0.25, 1)
#	point_light_2d.energy = clamp(point_light_2d.energy - 0.025 * delta, 0.25, 0.75)
	
	# Decrase monster's life overtime
	for monster in target_inside_light:
		monster.take_damage(
			light_damage * delta,
			red_torch_light.visible,
			green_torch_light.visible,
			blue_torch_light.visible
		)


func _physics_process(delta: float) -> void:
	move_and_slide()
	pass


func grow_light(amount):
	light_prepare_to_add = clampf(light_prepare_to_add + amount, 0.0, 1.0)


func grow_energy(color:String):
	color = color.to_lower()
	match color:
		"red":
			red_energy += 1
		"green":
			green_energy += 1
		"blue":
			blue_energy += 1


func take_damage(amount):
	health -= amount


func _on_torch_damage_body_entered(body: Node2D) -> void:
	if body is Monsters:
		target_inside_light.append(body)
	pass # Replace with function body.


func _on_torch_damage_body_exited(body: Node2D) -> void:
	if body is Monsters and body in target_inside_light:
		target_inside_light.erase(body)
	pass # Replace with function body.


func _on_one_second_timer_timeout() -> void:
	timer -= 1
