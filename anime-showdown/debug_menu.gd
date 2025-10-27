extends CanvasLayer
class_name UI

@onready var pp = $%Pp;
@onready var mp = $%Mp;
@onready var pd = $%Pd;
@onready var t = $%T;

var player_postion = Vector2i.ZERO;
var mouse_over_char = false;
var mouse_postion = Vector2i.ZERO;
var test = Vector2i.ZERO;

func update_player_postion(value: Vector2i) -> void:	
	player_postion = value
	update_player_postion_text()

func mouse_over_char_value(value: bool) -> void:	
	mouse_over_char = value;
	update_player_direction_text()

func update_mouse_postion(value: Vector2i) -> void:	
	mouse_postion = value;
	update_mouse_postion_text()
	
func update_test_postion(value: Vector2i) -> void:	
	test = value;
	update_test_postion_text()

	

func update_player_postion_text() -> void: 
	pp.text = "Player position: " + str(player_postion.x) + "," + str(player_postion.y);
	
func update_player_direction_text() -> void: 
	pd.text = "Mouse over char: " + str(mouse_over_char);
	
func update_mouse_postion_text() -> void: 
	mp.text = "Mouse position: " + str(mouse_postion.x) + "," + str(mouse_postion.y);

func update_test_postion_text() -> void: 
	t.text = "Mouse test position: " + str(test.x) + "," + str(test.y);
