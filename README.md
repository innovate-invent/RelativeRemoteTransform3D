# RelativeRemoteTransform3D

RelativeRemoteTransform3D pushes its own Transform3D with a relative coordinate space to another Node3D derived node (called the remote node) in the scene.

It can be set to update another Node's position, rotation and/or scale relative to another node.

This is functionally similar to the built-in [RemoteTransform3D](https://docs.godotengine.org/en/stable/classes/class_remotetransform3d.html). RemoteTransform3D transforms the remote relative to its parent node or the global origin.
RelativeRemoteTransform3D allows you to specify any node to position the remote relative to. This is often useful for positioning a second camera if you are trying to create mirrors or portals with [ViewportTexture](https://docs.godotengine.org/en/stable/classes/class_viewporttexture.html).

Three additional nodes are provided that allow breaking up RelativeRemoteTransform3D across your scene:
RelativeTransform3DTransmitter, RelativeTransform3DReceiver, and Transform3DObserver.

RelativeTransform3DTransmitter replaces RelativeRemoteTransform3D in the tree and transmits its relative transform to a RelativeTransform3DReceiver.

RelativeTransform3DReceiver applies the relative transform received from RelativeTransform3DTransmitter to its parent node.

Transform3DObserver has two purposes. If a Transform3DObserver is specified as the "Relative To" for either RelativeRemoteTransform3D or RelativeTransform3DTransmitter, 
then the relationship is reversed and the RelativeRemoteTransform3D/RelativeTransform3DTransmitter will use the Transform3D of the Transform3DObserver and use their own Transform3D as the "Relative To" transform.
This is useful if you have a lot of RelativeRemoteTransform3D/RelativeTransform3DTransmitter tracking the same Node3D. Set Transform3DObserver as a child of the Node3D you want to track and give it a 
[Unique Name](https://docs.godotengine.org/en/stable/tutorials/scripting/scene_unique_nodes.html).
Set the "Relative To" to the Unique Name preceded by % and you can freely place RelativeRemoteTransform3D/RelativeTransform3DTransmitter as children of the relative nodes throughout the scene.

The second use of Transform3DObserver is to allow the nodes to be informed of Transform3D changes of the "Relative To" and "Remote Relative To" nodes. Refer to Transform3DObserver nodes for these fields to receive 
updates to the relative nodes.

Special thanks to Lauren Wrubleski (@lawruble13) for the maths required for this plugin.

