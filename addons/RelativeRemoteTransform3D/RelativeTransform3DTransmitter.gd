@tool
@icon("res://RelativeRemoteTransform3D.svg")
#class_name RelativeTransform3DTransmitter
extends Node3D

const Common = preload("common.gd")
const Transform3DObserver = preload("Transform3DObserver.gd")
const RelativeTransform3DReceiver = preload("RelativeTransform3DReceiver.gd")

@export_category("RelativeTransform3DTransmitter")

## [Node3D] to calculate transforms relative to
@export_node_path("RelativeTransform3DReceiver") var receiver: NodePath:
	set(v):
		receiver = v
		force_update_cache()
var _receiver: RelativeTransform3DReceiver

## [Node3D] to calculate transforms relative to
@export_node_path("Node3D") var relative_to: NodePath:
	set(v):
		relative_to = v
		force_update_cache()
var _relative_to: Node3D

## Force the provided NodePaths to re-evaluate
func force_update_cache():
	if not receiver.is_empty():
		_receiver = get_node_or_null(receiver)
		if _receiver and _receiver._relative_to and _receiver._relative_to is Transform3DObserver and not _receiver._relative_to.moved.is_connected(transmit):
			_receiver._relative_to.move.connect(transmit)
	if not relative_to.is_empty():
		_relative_to = get_node_or_null(relative_to)
		if _relative_to and _relative_to is Transform3DObserver and not _relative_to.moved.is_connected(transmit):
			_relative_to.moved.connect(transmit)
		
func _ready():
	set_notify_transform(true)
	transmit()
	force_update_cache()

func _exit_tree():
	if _relative_to is Transform3DObserver and _relative_to.moved.is_connected(transmit):
		_relative_to.moved.disconnect(transmit)
	if _receiver and _receiver._relative_to and _receiver._relative_to is Transform3DObserver and _receiver._relative_to.moved.is_connected(transmit):
		_receiver._relative_to.move.disconnect(transmit)

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED and not _relative_to is Transform3DObserver:
		transmit()

func transmit():
	if _receiver and _relative_to:
		_receiver.transform(Common.to_relative_transform(
			_relative_to.get_global_transform() if _relative_to is Transform3DObserver and _relative_to.reverse_relationship else get_global_transform(), 
			 get_global_transform() if _relative_to is Transform3DObserver and _relative_to.reverse_relationship else _relative_to.get_global_transform(),
			))
