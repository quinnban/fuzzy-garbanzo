extends CanvasLayer
class_name UI

@onready var l1 = $%L1;
@onready var l2 = $%L2;
@onready var l3 = $%L3;
@onready var l4 = $%L4;

var l1_t : String = "";
var l2_t : String = "";
var l3_t : String = "";
var l4_t : String = "";

func update_line_1(value: String) -> void:	
	l1_t = value
	update_line_1_text()

func update_line_2(value: String) -> void:	
	l2_t = value;
	update_line_2_text()

func update_line_3(value: String) -> void:	
	l3_t = value;
	update_line_3_text()
	
func update_line_4(value: String) -> void:	
	l4_t = value;
	update_line_4_text()

func update_line_1_text() -> void: 
	l1.text = l1_t
	
func update_line_2_text() -> void: 
	l2.text = l2_t
	
func update_line_3_text() -> void: 
	l3.text = l3_t

func update_line_4_text() -> void: 
	l4.text = l4_t
