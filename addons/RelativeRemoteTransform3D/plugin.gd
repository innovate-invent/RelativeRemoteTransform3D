@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("RelativeRemoteTransform3D", "Node3D", preload("RelativeRemoteTransform3D.gd"), preload("RelativeRemoteTransform3D.svg"))
	add_custom_type("RelativeTransform3DEmitter", "Node3D", preload("RelativeTransform3DTransmitter.gd"), preload("RelativeRemoteTransform3D.svg"))
	add_custom_type("RelativeTransform3DReceiver", "Node3D", preload("RelativeTransform3DReceiver.gd"), preload("RelativeTransform3DReceiver.svg"))
	add_custom_type("Transform3DObserver", "Node3D", preload("Transform3DObserver.gd"), preload("Transform3DObserver.svg"))

func _exit_tree():
	remove_custom_type("RelativeRemoteTransform3D")
	remove_custom_type("RelativeTransform3DEmitter")
	remove_custom_type("RelativeTransform3DReceiver")
	remove_custom_type("Transform3DObserver")
