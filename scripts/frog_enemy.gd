extends CharacterBody2D


var SPEED = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D

var player
var chase = false

func _physics_process(delta):
	# gravity for frog
	velocity.y += gravity * delta
	
	# Go to player if in range
	if chase and animated_sprite.animation != "death":
		animated_sprite.play("jump")
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			animated_sprite.flip_h = true
		else:	
			animated_sprite.flip_h = false
		velocity.x = direction.x * SPEED
	elif animated_sprite.animation != "death":
		animated_sprite.play("idle")
		velocity.x = 0
	
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false

func _on_player_death_body_entered(body):
	if body.name == "Player":
		chase = false
		animated_sprite.play("death")
		await animated_sprite.animation_finished
		self.queue_free()
