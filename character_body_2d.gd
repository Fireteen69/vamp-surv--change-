extends CharacterBody2D


@export var speed = 150
@export var stamina_drain = 1.5
@onready var animated_sprite = $AnimatedSprite2D
var new_direction: Vector2 = Vector2.ZERO
var animation: String
var is_attacking = false

var is_sprinting = false
var sprint_speed = 300
var ammo_amount = 1000


#ui variables
var health = 100
var regen_health = 1
var max_health =  100
var stamina = 100
var max_stamina = 100
var regen_stamina = 15

enum pickups { AMMO, STAMINA, HEALTH }
var health_pickup_amount = 0
var stamina_pickup_amount = 0


#ui signals
signal health_upd
signal stamina_upd
signal ammo_amount_upd
signal health_amount_upd
signal stamina_amount_upd

#bullet

#@onready var bullet_scene = preload("res://Scenes/Bullet.tscn")
var bullet_damage = 30
var damage = 30
var bullet_reload_time = 5
var bullet_fired_time = 0.5


func _process(delta: float) -> void:
	
	var updated_health = clamp(health + regen_health * delta,0, max_health)
	if updated_health != health: 
		health = updated_health
		health_upd.emit(health, max_health)
	
	
	var updated_stamina = clamp(stamina + regen_stamina * delta,0, max_stamina)
	if updated_stamina != stamina: 
		stamina = updated_stamina
		stamina_upd.emit(stamina, max_stamina)


func _physics_process(delta):
	
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
		
	
	var movement = direction * speed * delta
	if is_attacking == false:
		move_and_collide(movement)
		playerDirection(direction)

func playerDirection(direction: Vector2):
	if direction != Vector2.ZERO:
		new_direction = direction
		animation = "walk_" + returnedDirection(new_direction)
		animated_sprite.play(animation)
	else:
		animation = "idle_" + returnedDirection(direction)
		animated_sprite.play(animation)


func returnedDirection(direction: Vector2):
	var normalized_direction = direction.normalized()
	var default_return = "down"
	
	if normalized_direction.y > 0:
		return "down"
	elif normalized_direction.y < 0:
		return "up"
	elif normalized_direction.x > 0:
		animated_sprite.flip_h = false
		return "side"
	elif normalized_direction.x < 0 and normalized_direction.y == 0:
		animated_sprite.flip_h = true
		return "side"
		
		
	return default_return

func _input(event):
	if event.is_action_pressed("shoot"):
		animated_sprite.speed_scale = 1
		var now = Time.get_ticks_msec()
		if now >= bullet_fired_time and ammo_amount > 0:
			is_attacking = true
			animation = "attack_" + returnedDirection(new_direction)
			print("balls")
			animated_sprite.play(animation)
			bullet_fired_time = now + bullet_reload_time
			ammo_amount = ammo_amount - 1
			ammo_amount_upd.emit(ammo_amount)
			
	if Input.is_action_pressed("sprint"):
		if stamina > 0:
			speed = sprint_speed
			animated_sprite.speed_scale = 2
			stamina = stamina - stamina_drain
			stamina_upd.emit(stamina, max_stamina)
		if stamina < 0:
			speed = 150
			animated_sprite.speed_scale = 1
			Input.is_action_just_released("sprint")
	elif Input.is_action_just_released("sprint"):
		speed = 150
		animated_sprite.speed_scale = 1


		




func _on_animated_sprite_2d_animation_finished():
	print("finish attacking")
	is_attacking = false

