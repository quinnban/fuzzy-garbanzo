extends CharacterBody2D


@onready var animated_sprite = $AnimatedSprite2D


func _ready() -> void:
	animated_sprite.stop();
	animated_sprite.play("default");

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if direction != Vector2.ZERO:
		velocity = direction * 64
		if(Input.is_action_pressed("ui_down")):
			animated_sprite.play("down")
		if(Input.is_action_pressed("ui_left")):
			animated_sprite.play("left")
		if(Input.is_action_pressed("ui_right")):
			animated_sprite.play("right")
		if(Input.is_action_pressed("ui_up")):
			animated_sprite.play("up")
			
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("default");
	move_and_slide()
