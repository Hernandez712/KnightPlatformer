
extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	if body.is_in_group("dead"):
		return

	print("You died!")
	body.add_to_group("dead")

	# Slow down time
	Engine.time_scale = 0.5

	# Get player sprite
	var sprite = body.get_node("AnimatedSprite2D")

	# Turn player red
	sprite.modulate = Color.RED

	# Create blood particles
	var particles = CPUParticles2D.new()

	particles.emitting = false
	particles.amount = 35
	particles.lifetime = 0.7
	particles.one_shot = true
	particles.explosiveness = 1.0

	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	particles.emission_sphere_radius = 8.0

	particles.direction = Vector2(0, -1)
	particles.spread = 180.0

	particles.initial_velocity_min = 100.0
	particles.initial_velocity_max = 250.0

	particles.gravity = Vector2(0, 450)

	particles.scale_amount_min = 2.0
	particles.scale_amount_max = 5.0

	particles.color = Color(0.85, 0.02, 0.03, 1.0)

	# Add particles to scene
	get_tree().current_scene.add_child(particles)
	particles.global_position = body.global_position
	particles.emitting = true

	# Rotate player
	var tween = create_tween()
	tween.tween_property(body, "rotation", deg_to_rad(360), 0.6)

	# Remove player collision
	body.get_node("CollisionShape2D").queue_free()

	# Restart timer
	timer.start()


func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
