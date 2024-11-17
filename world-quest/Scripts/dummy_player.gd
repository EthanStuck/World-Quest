extends CharacterBody2D

var speed = 75
var direction = Vector2(0,0)
var continued = false

func _process(delta):
	if not continued:
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

func continue_pressed(anim):
	''' play corresponding strike animation '''
	continued = true
	$Animations.play(anim)
	$Animations.frame = 1
