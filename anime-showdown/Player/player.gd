extends CharacterBody2D


@onready var animated_sprite = $AnimatedSprite2D

@onready var tilemap = get_parent()
@onready var layer1 = tilemap.get_node("Layer 1")
@onready var layer2 = tilemap.get_node("Layer 2")
@onready var layer3 = tilemap.get_node("Layer 3")

var last_cell: Vector2i = Vector2i(-1, -1)
var last_tile_id: int = 3;

func _process(delta: float) -> void:
	
	var y_offset = 64 * 0.5
	var current_global_pos = global_position + Vector2(0, -y_offset)
	var current_local_pos = layer1.to_local(current_global_pos)
	var current_cell = layer1.local_to_map(current_local_pos)
	if current_cell != last_cell:
		if last_cell != Vector2i(-1, -1):
			set_tile_at_position(last_cell,last_tile_id)
			set_last_tile_id(last_cell)
		set_tile_at_position(current_cell,4)
		last_cell = current_cell
		
		
		
	
func set_tile_at_position(cell_pos: Vector2i, tileId: int):
	if layer1.isInLayer(cell_pos):
		layer1.set_cell( cell_pos, tileId, Vector2i.ZERO)
	if layer2.isInLayer(cell_pos):
		layer2.set_cell( cell_pos, tileId, Vector2i.ZERO)
	if layer3.isInLayer(cell_pos):
		layer3.set_cell( cell_pos, tileId, Vector2i.ZERO)
	
	
func set_last_tile_id(cell_pos: Vector2i):
	if layer1.isInLayer(cell_pos):
		last_tile_id = layer1.getTileId(cell_pos)
	if layer2.isInLayer(cell_pos):
		last_tile_id = layer2.getTileId(cell_pos)
	if layer3.isInLayer(cell_pos):
		last_tile_id =layer3.getTileId(cell_pos)
	

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
