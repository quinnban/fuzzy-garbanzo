extends CharacterBody2D


@onready var animated_sprite = $AnimatedSprite2D

@onready var map = get_parent()
@onready var layer1 = map.get_node("Layer 1")
@onready var layer2 = map.get_node("Layer 2")
@onready var layer3 = map.get_node("Layer 3")
@onready var ui = map.get_node("DebugMenu")

var movementRange: int = 2;
var state = Enums.PLAYER_STATE.IDLE;

func _process(delta: float) -> void:
	update_mouse_debug()
	var current_global_pos = global_position
	var current_local_pos = layer1.to_local(current_global_pos)
	current_local_pos.x = floor(current_local_pos.x);
	current_local_pos.y = floor(current_local_pos.y);
	var current_cell = layer1.local_to_map(current_local_pos)
	ui.update_line_1("Player cell: " + str(current_cell))
	#if current_cell != last_cell:
		#if last_cell != Vector2i(-1, -1):
			#set_tile_at_position(last_cell,last_tile_id)
			#set_last_tile_id(last_cell)
		#set_tile_at_position(current_cell,5)
		#last_cell = current_cell

func set_tile_at_position(cell_pos: Vector2i, tileId: int):
	if layer1.isInLayer(cell_pos):
		layer1.set_cell( cell_pos, tileId, Vector2i.ZERO)
	if layer2.isInLayer(cell_pos):
		layer2.set_cell( cell_pos, tileId, Vector2i.ZERO)
	if layer3.isInLayer(cell_pos):
		layer3.set_cell( cell_pos, tileId, Vector2i.ZERO)

func update_mouse_debug() -> void: 
	var mouse_position_viewport = get_global_mouse_position()
	var mouse_local_pos = layer1.to_local(mouse_position_viewport)
	mouse_local_pos.x = floor(mouse_local_pos.x);
	mouse_local_pos.y = floor(mouse_local_pos.y);
	var mouse_cell = layer1.local_to_map(mouse_local_pos);
	ui.update_line_2("Mouse cell: " + str(mouse_cell))

func get_player_tile() -> Vector2i:
	var current_local_pos = layer1.to_local(global_position)
	current_local_pos.x = floor(current_local_pos.x);
	current_local_pos.y = floor(current_local_pos.y);
	var current_cell = layer1.local_to_map(current_local_pos)
	return current_cell

func _ready() -> void:
	animated_sprite.stop();
	animated_sprite.play("default");

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
