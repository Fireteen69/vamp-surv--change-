extends CharacterBody2D

var player = get_tree().root.get_node("main/Player")
var direction: Vector2 = Vector2.ZERO
var new_direction = Vector2(0, 1)
var timer = 0

var rng = RandomNumberGenerator.new()

func _on_timer_timeout():
	var player_distance = player.position - position
	if player_distance.length() <= 20:
		new_direction = player_distance.normalized()
	elif player_distance.length() <= 100 and timer == 0:
		direction = player_distance.normalized()
	elif timer == 0:
		var random_direction = rng.randf()
		if random_direction < 0.05:
			direction = Vector2.ZERO
		elif random_direction < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
