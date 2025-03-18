extends CharacterBody2D

@onready var player = $"../Player"
var direction: Vector2 = Vector2.ZERO
var new_direction = Vector2(0, 1)
var timer = 0
var speed = 150

var rng = RandomNumberGenerator.new()

func _physics_process(delta):
	var movement = speed * direction * delta
	var collision = move_and_collide(movement)
	if collision != null and collision.get_collider().name != "player":
		direction = direction.rotated(rng.randf_range(PI / 4, PI / 2))
		timer = rng.randf_range(2, 5)
	else:
		timer = 0
#jfopaibnfd

func _on_timer_timeout():
	if player != null:
		var player_distance = player.position - position
		if player_distance.length() <= 50:
			new_direction = player_distance.normalized()
		elif player_distance.length() <= 700 and timer <= 0:
			direction = player_distance.normalized()
		elif timer <= 0:
			var random_direction = rng.randf()
			if random_direction < 0.05:
				direction = Vector2.ZERO
			elif random_direction < 0.1:
				direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
	
