@tool
@icon("res://RelativeRemoteTransform3D.svg")
#class_name RelativeRemoteTransform3D
extends Node3D

@export_category("RelativeRemoteTransform3D")

## [Node3D] to calculate transforms relative to
@export_node_path("Node3D") var relative_to: NodePath
var _relative_to: Node3D

## [Node3D] to apply transform
@export_node_path("Node3D") var remote: NodePath
var _remote: Node3D

## Remote is positioned relative to this specified [Node3D]
@export_node_path("Node3D") var remote_relative_to: NodePath
var _remote_relative_to: Node3D

@export_group("Flip Axis")

## Flip the X axis of the transform
@export var flip_x = false

## Flip the Y axis of the transform
@export var flip_y = false

## Flip the Z axis of the transform
@export var flip_z = false

@export_group("Update", "update_")

## Restrict updating the position of the remote
@export var update_position: bool = true

## Restrict updating the rotation of the remote
@export var update_rotation: bool = true

## Restrict updating the scale of the remote
@export var update_scale: bool = true

## Force the 
func force_update_cache():
	_relative_to = get_node(relative_to)
	_remote = get_node(remote)
	_remote_relative_to = get_node(remote_relative_to)
	update()

func _ready():
	force_update_cache()

func _enter_tree():
	set_notify_transform(true);

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		update()

func update():
	var xform := get_global_transform()
	var relative := _relative_to.get_global_transform()
	var remote_xform := _remote.get_global_transform()
	var remote_relative := _remote_relative_to.get_global_transform()
	var flip := Basis.from_scale(Vector3i(-1 if flip_x else 1, -1 if flip_y else 1, -1 if flip_z else 1))
	var remote_basis := remote_relative.basis.orthonormalized() * flip * relative.basis.orthonormalized().inverse()

	if update_position:
		remote_xform.origin = (remote_basis * (xform.origin - relative.origin)) + remote_relative.origin
		
	remote_basis = remote_basis * xform.basis.orthonormalized()
	if update_rotation && update_scale:
		remote_xform.basis = remote_basis
	elif update_rotation || update_scale:
		var kept_scale := remote_basis if update_scale else remote_xform.basis.orthonormalized()
		var kept_rotation := remote_basis if update_rotation else remote_xform.basis.orthonormalized()
		remote_xform.basis = Basis.from_euler(kept_rotation.get_euler()) * Basis.from_scale(kept_scale.get_scale())

	_remote.set_global_transform(remote_xform)
		
	
	
