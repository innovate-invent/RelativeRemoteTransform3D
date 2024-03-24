@tool
@icon("res://RelativeTransform3DReceiver.svg")
class_name RelativeTransform3DReceiver
extends Node

const Common = preload("common.gd")

@export_category("RelativeTransform3DReceiver")

## [Node3D] to calculate transforms relative to
@export_node_path("Node3D") var relative_to: NodePath:
	set(v):
		relative_to = v
		force_update_cache()
var _relative_to: Node3D

@export_group("Flip Axis")

## Flip the X axis of the transform
@export var flip_x = false:
	set(v):
		flip_x = v
		_update_flip()

## Flip the Y axis of the transform
@export var flip_y = false:
	set(v):
		flip_y = v
		_update_flip()

## Flip the Z axis of the transform
@export var flip_z = false:
	set(v):
		flip_z = v
		_update_flip()

@export_group("Update", "update_")

## Restrict updating the position of the remote
@export var update_position: bool = true

## Restrict updating the rotation of the remote
@export var update_rotation: bool = true

## Restrict updating the scale of the remote
@export var update_scale: bool = true

var flip: Basis

func _update_flip():
	flip = Basis.from_scale(Vector3i(-1 if flip_x else 1, -1 if flip_y else 1, -1 if flip_z else 1))

func transform(relative_xform: Transform3D):
	if not _relative_to:
		if OS.is_debug_build():
			push_warning("No relative node found for %s" % get_path())
		return
	var parent := get_parent() as Node3D
	var relative := _relative_to.get_global_transform()
	relative.basis = relative.basis.orthonormalized() * flip
	var xform := Common.from_realtive_transform(relative_xform, relative)
	if update_rotation || update_scale:
		xform.basis = xform.basis.orthonormalized()
	parent.set_global_transform(Common.update_transform(parent.get_global_transform(), xform, update_position, update_rotation, update_scale))

## Force the provided NodePaths to re-evaulate
func force_update_cache():
	if not relative_to.is_empty():
		_relative_to = get_node_or_null(relative_to)

func _ready():
	force_update_cache()
	_update_flip()

func _enter_tree():
	assert(get_parent() is Node3D, "Parent must be of type Node3D")
