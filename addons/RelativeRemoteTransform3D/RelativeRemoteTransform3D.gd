@tool
@icon("res://RelativeRemoteTransform3D.svg")
#class_name RelativeRemoteTransform3D
extends Node3D

const Common = preload("common.gd")
const Transform3DObserver = preload("Transform3DObserver.gd")

@export_category("RelativeRemoteTransform3D")

## [Node3D] to calculate transforms relative to
@export_node_path("Node3D") var relative_to: NodePath:
	set(v):
		relative_to = v
		force_update_cache()
var _relative_to: Node3D

## [Node3D] to apply transform
@export_node_path("Node3D") var remote: NodePath:
	set(v):
		remote = v
		force_update_cache()
var _remote: Node3D

## Remote is positioned relative to this specified [Node3D]
@export_node_path("Node3D") var remote_relative_to: NodePath:
	set(v):
		remote_relative_to = v
		force_update_cache()
var _remote_relative_to: Node3D

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

## Force the 
func force_update_cache():
	if not relative_to.is_empty():
		_relative_to = get_node_or_null(relative_to)
		if _relative_to and _relative_to is Transform3DObserver and not _relative_to.moved.is_connected(update):
			_relative_to.moved.connect(update)
	if not remote.is_empty():
		_remote = get_node_or_null(remote)
	if not remote_relative_to.is_empty():
		_remote_relative_to = get_node_or_null(remote_relative_to)
		if _remote_relative_to and _relative_to is Transform3DObserver and not _remote_relative_to.moved.is_connected(update):
			_remote_relative_to.moved.connect(update)
	update()

func _ready():
	force_update_cache()
	_update_flip()

func _enter_tree():
	set_notify_transform(true)
	
func _exit_tree():
	if _relative_to is Transform3DObserver and _relative_to.moved.is_connected(update):
		_relative_to.moved.disconnect(update)

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		update()

func update():
	if not (_remote and _relative_to and _remote_relative_to):
		return
	var remote_relative := _remote_relative_to.get_global_transform()
	var relative := Common.to_relative_transform(
		_relative_to.get_global_transform() if _relative_to is Transform3DObserver and _relative_to.reverse_relationship else get_global_transform(), 
		get_global_transform() if _relative_to is Transform3DObserver and _relative_to.reverse_relationship else _relative_to.get_global_transform(),
		)
	remote_relative.basis = remote_relative.basis.orthonormalized() * flip

	var new_xform := Common.from_realtive_transform(relative, remote_relative)
	if update_rotation || update_scale:
		new_xform.basis = new_xform.basis.orthonormalized()

	_remote.set_global_transform(Common.update_transform(_remote.get_global_transform(), new_xform, update_position, update_rotation, update_scale))
