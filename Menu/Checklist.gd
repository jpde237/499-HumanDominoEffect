extends Control


var CMAX=10 # max checklist size
var CMIN=0  # min checklist size
var checklist = [] #array that stores checklist
var isRemoving = false #bool value for checking if item needs to be removed
var isNaming = false
var itemName = "New Checklist Item"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#
	$CanvasLayer/TextureRect/add_item/WindowDialog.hide()
	if not $CanvasLayer/TextureRect/add_item.is_connected("pressed", self, "_on_add_item_pressed"):
		$CanvasLayer/TextureRect/add_item.connect("pressed", self, "_on_add_item_pressed")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	

func _on_add_item_pressed():
	#create new check box
	$CanvasLayer/TextureRect/add_item/WindowDialog.show()
	#while ():
		
	var new_item = create_checklist_item(itemName)
	# add checkbox to container
	var vbox=$CanvasLayer/TextureRect/VBoxContainer
	if vbox && checklist.size()<CMAX:
		vbox.add_child(new_item)
		checklist.append(new_item)
func create_checklist_item(text):
	var item = CheckBox.new()
	item.text = text
	#item.connect("toggled", self, "_on_item_toggled", [item])
	item.connect("pressed", self, "_on_item_pressed", [item])
	return item

func _on_item_pressed(item):
	if  isRemoving && checklist.size()>CMIN:
		remove_item(item)
		
		
	#check button
func remove_item(item):
	if item in checklist:
		checklist.erase(item)
		var vbox = $CanvasLayer/TextureRect/VBoxContainer
		if vbox:
			vbox.remove_child(item)
			item.queue_free()

func _on_remove_item_pressed():
	isRemoving = not isRemoving


	
func _on_Rename_pressed():
	isNaming = not isNaming


func _on_Confirm_pressed():
	
	$CanvasLayer/TextureRect/add_item/WindowDialog.show()
	pass # Replace with function body.


func _on_LineEdit_text_entered(new_text):
	
	pass # Replace with function body.
