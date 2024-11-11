extends CharacterBody2D

var speed = 75
var direction = Vector2(0,0)

func _process(delta):
	velocity = direction.normalized() * speed
	if velocity.x > 0:
		$Animations.play('walk_right')
	elif velocity.x < 0:
		$Animations.play('walk_left')
	elif velocity.y > 0:
		$Animations.play('walk_front')
	elif velocity.y < 0:
		$Animations.play('walk_back')
	else:
		$Animations.play('spin')
	position += velocity * delta
		
