@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("RelativeRemoteTransform3D", "Node3D", preload("RelativeRemoteTransform3D.gd"), preload("RelativeRemoteTransform3D.svg"))

func _exit_tree():
	remove_custom_type("RelativeRemoteTransform3D")
