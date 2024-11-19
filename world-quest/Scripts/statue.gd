extends StaticBody2D

var interactable = false


func _ready():
	''' set the visual state of the statue depending on game completion '''
	$FullSprite.z_index = position.y + 80
	$BaseSprite.z_index = position.y + 80
	$'Fragment-BL'.z_index = position.y + 7
	$'Fragment-BR'.z_index = position.y + 7
	$'Fragment-TL'.z_index = position.y + 10
	$'Fragment-TL'.z_index = position.y + 10
	$Statue_comp_animation.hide()
	
	if not FragmentHandler.west_added or not FragmentHandler.north_added or not FragmentHandler.south_added or not FragmentHandler.east_added:
		$FullSprite.hide()
	if not FragmentHandler.south_added:
		$'Fragment-BL'.hide()
	if not FragmentHandler.east_added:
		$'Fragment-BR'.hide()
	if not FragmentHandler.west_added:
		$'Fragment-TL'.hide()
	if not FragmentHandler.north_added:
		$'Fragment-TR'.hide()
	$InteractLabel.hide()
	

func _process(delta):
	if Input.is_action_just_pressed('interact'):
		add_fragment()
	if FragmentHandler.west_added and FragmentHandler.north_added and FragmentHandler.south_added and FragmentHandler.east_added:
		$FullSprite.show()
		$CompletionSound.play()
		$Statue_comp_animation.show()


func add_fragment():
	''' Function for player to add fragments to the statue '''
	if interactable:
		$InteractLabel.hide()
		
		if FragmentHandler.west_fragment:
			$'Fragment-TL'.show()
			$CompletionSound.play()
			FragmentHandler.west_fragment = false
			FragmentHandler.west_complete = true
			FragmentHandler.west_added = true
			
		if FragmentHandler.north_fragment:
			$'Fragment-TR'.show()
			$CompletionSound.play()
			FragmentHandler.north_fragment = false
			FragmentHandler.north_complete = true
			FragmentHandler.north_added = true
			
		if FragmentHandler.south_fragment:
			$'Fragment-BL'.show()
			$CompletionSound.play()
			FragmentHandler.south_fragment = false
			FragmentHandler.south_complete = true
			FragmentHandler.south_added = true
			
		if FragmentHandler.east_fragment:
			$'Fragment-BR'.show()
			$CompletionSound.play()
			FragmentHandler.east_fragment = false
			FragmentHandler.east_complete = true
			FragmentHandler.east_added = true


func _on_interact_zone_area_entered(area: Area2D) -> void:
	''' if player enters area '''
	if FragmentHandler.east_fragment or FragmentHandler.west_fragment or FragmentHandler.north_fragment or FragmentHandler.south_fragment:
		$InteractLabel.show()
		interactable = true


func _on_interact_zone_area_exited(area: Area2D) -> void:
	''' if player leaves area '''
	$InteractLabel.hide()
	interactable = false
