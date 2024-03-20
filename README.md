# RelativeRemoteTransform3D

RelativeRemoteTransform3D pushes its own Transform3D with a relative coordinate space to another Node3D derived node (called the remote node) in the scene.

It can be set to update another Node's position, rotation and/or scale relative to another node.

This is functionally similar to the built-in [RemoteTransform3D](https://docs.godotengine.org/en/stable/classes/class_remotetransform3d.html). RemoteTransform3D transforms the remote relative to its parent node or the global origin.
RelativeRemoteTransform3D allows you to specify any node to position the remote relative to. This is often useful for positioning a second camera if you are trying to create mirrors or portals with [ViewportTexture](https://docs.godotengine.org/en/stable/classes/class_viewporttexture.html).

Special thanks to Lauren Wrubleski (@lawruble13) for the maths required for this plugin.

