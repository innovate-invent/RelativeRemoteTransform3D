@tool
@icon("res://Transform3DObserver.svg")
#class_name Transform3DObserver
extends Node3D

signal moved()

@export_category("Transform3DObserver")

## Reverse the relative relationship with the referring node
@export var reverse_relationship: bool = true

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		moved.emit()

func _enter_tree():
	set_notify_transform(true)
