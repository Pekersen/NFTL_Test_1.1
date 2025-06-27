class_name TechTree
extends GraphEdit

@onready var children := get_children()

func _ready():
	scroll_offset.x = -get_viewport().get_visible_rect().size.x
	show_grid_buttons = false
	for child in children:
		if !(child is TechTreeElement):
			continue
		# connect signals
		child.obtained.connect(_on_element_obtained)
		
		# determine if able to click on element
		child.selectable = _completed_all_prerequisites(child)
		if !child.selectable:
			child.set_slot_color_left(0, Color.DIM_GRAY)
			child.prerequisites.map(func(prereq): prereq.set_slot_color_right(0, Color.DIM_GRAY))
		
		# connect elements
		if !child.prerequisites.is_empty():
			_connect_all_prerequisites(child)
		else:
			child.set_slot_enabled_left(0, false)
		if child.dependents.is_empty():
			child.set_slot_enabled_right(0, false)

func _connect_all_prerequisites(element : TechTreeElement) -> void:
	element.prerequisites.map(func(prereq): _connect_prerequisite(element, prereq))
	
func _connect_prerequisite(element : TechTreeElement, prerequisite : TechTreeElement) -> void:
	connect_node(prerequisite.name, 0, element.name, 0)

func _completed_all_prerequisites(element : TechTreeElement) -> bool:
	# true if all prerequisites obtained
	return !element.prerequisites.any(
		func(tech_tree_elm): return !tech_tree_elm.is_obtained
		) #TODO: add 'and ____' (for other prerequisites)

func _on_element_obtained(element : TechTreeElement):
	# Make depends selectable if completed prerequisites
	for dependent in element.dependents:
		dependent.selectable = _completed_all_prerequisites(dependent)
		if dependent.selectable:
			dependent.set_slot_color_left(0, Color.WHITE)

	element.set_slot_color_right(0, Color.WHITE)	

func _on_connection_request(from_node, from_port, to_node, to_port):
	connect_node(from_node, from_port, to_node, to_port)
