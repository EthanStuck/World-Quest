extends TextureProgressBar

@export var player: Player

func _ready():
	player.health_update.connect(update_health)
	update_health()

func update_health():
	value = player.currentHealth * 100 / player.maxHealth
