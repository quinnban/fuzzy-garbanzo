extends CharacterBody2D


@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = $HealthBar
@onready var static_health_bar = $CanvasLayer/HealthBar
@onready var static_health_canvas = $CanvasLayer

@onready var map = get_parent()
@onready var terrain_map = map.get_node("terrain")
@onready var ui = map.get_node("DebugMenu")


var movementRange: int = 3;
var characterInfoDisplayed = false;
var state = Enums.PLAYER_STATE.IDLE;
const speed = 64;

func _process(_delta: float) -> void:
	update_mouse_debug()
	var current_global_pos = global_position
	var current_local_pos = terrain_map.to_local(current_global_pos)
	current_local_pos.x = floor(current_local_pos.x);
	current_local_pos.y = floor(current_local_pos.y);
	var current_cell = terrain_map.local_to_map(current_local_pos)
	ui.update_line_1("Player cell: " + str(current_cell))
	
func _ready() -> void:
	var health = 6
	static_health_canvas.hide()
	static_health_bar.init_health(health)
	health_bar.init_health(health)
	animated_sprite.stop();
	animated_sprite.play("default");

func set_tile_at_position(cell_pos: Vector2i, tileId: int):
	if terrain_map.isInLayer(cell_pos):
		terrain_map.set_cell( cell_pos, tileId, Vector2i.ZERO)

func update_mouse_debug() -> void: 
	var mouse_position_viewport = get_global_mouse_position()
	var mouse_local_pos = terrain_map.to_local(mouse_position_viewport)
	mouse_local_pos.x = floor(mouse_local_pos.x);
	mouse_local_pos.y = floor(mouse_local_pos.y);
	var mouse_cell = terrain_map.local_to_map(mouse_local_pos);
	ui.update_line_2("Mouse cell: " + str(mouse_cell))

func get_player_tile() -> Vector2i:
	var current_local_pos = terrain_map.to_local(global_position)
	current_local_pos.x = floor(current_local_pos.x);
	current_local_pos.y = floor(current_local_pos.y);
	var current_cell = terrain_map.local_to_map(current_local_pos)
	return current_cell

#func _physics_process(delta: float) -> void:
	#var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	#if direction != Vector2.ZERO:
		#velocity = direction * 64
		#if(Input.is_action_pressed("ui_down")):
			#animated_sprite.play("down")
		#if(Input.is_action_pressed("ui_left")):
			#animated_sprite.play("left")
		#if(Input.is_action_pressed("ui_right")):
			#animated_sprite.play("right")
		#if(Input.is_action_pressed("ui_up")):
			#animated_sprite.play("up")
			#
	#else:
		#velocity = Vector2.ZERO
		#animated_sprite.play("default");
	#move_and_slide()

func move_player_on_path(path: Array[Vector2i]) -> void:
	state = Enums.PLAYER_STATE.MOVING
	for node in path:
		var delta_x = get_player_tile().x  - node.x
		var delta_y = get_player_tile().y - node.y
		if delta_x > 0:
			animated_sprite.play("left")
			await move_postion(Enums.DIRECTION.LEFT)
		elif delta_x < 0:
			animated_sprite.play("right")
			await move_postion(Enums.DIRECTION.RIGHT)
		elif delta_y > 0:
			animated_sprite.play("up")
			await move_postion(Enums.DIRECTION.UP)
		elif delta_y < 0:
			animated_sprite.play("down")
			await move_postion(Enums.DIRECTION.DOWN)
		##await get_tree().create_timer(0.5).timeout
	_toggle_character_stats()
	state = Enums.PLAYER_STATE.IDLE
	animated_sprite.play("default");
		
func move_postion(direction) -> void:
	for i in range(8):
		match direction:
			Enums.DIRECTION.UP:
				position.x += 2
				position.y -= 1
			Enums.DIRECTION.DOWN:
				position.x -= 2
				position.y +=1
			Enums.DIRECTION.LEFT:
				position.x -= 2
				position.y -= 1
			Enums.DIRECTION.RIGHT:
				position.x += 2
				position.y += 1
		await get_tree().create_timer(0.03).timeout

func _set_health(value):
	#super._set_health(value)
	#if health <= 0:
		# die
			
	health_bar.health = value
	static_health_bar.health = value

func _toggle_character_stats():
	if characterInfoDisplayed:
		static_health_canvas.hide()
	else:
		static_health_canvas.show()
	characterInfoDisplayed = !characterInfoDisplayed
