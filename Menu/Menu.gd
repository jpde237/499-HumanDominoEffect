class_name Menu
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Lobby.hide()
	$Checklist/CanvasLayer.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_gotolobby_pressed():
	$MenuLayout.hide()
	$Checklist/CanvasLayer.hide()
	$Lobby.show()
	




func _on_Checklist_pressed():
	$Lobby.hide()
	$Checklist/CanvasLayer.show()


func _on_remove_item_pressed():
	pass # Replace with function body.
