extends Object

static func to_relative_transform(xform: Transform3D, relative_xform: Transform3D) -> Transform3D:
	var basis := relative_xform.basis.orthonormalized().inverse()
	return Transform3D(
		basis * xform.basis.orthonormalized(),
		basis * (xform.origin - relative_xform.origin)
	)

static func from_realtive_transform(xform: Transform3D, relative_xform: Transform3D) -> Transform3D:
	return Transform3D(
		relative_xform.basis * xform.basis,
		(relative_xform.basis * xform.origin) + relative_xform.origin
	)

static func update_transform(to: Transform3D, from: Transform3D, update_position: bool, update_rotation: bool, update_scale: bool):
	if update_position:
		to.origin = from.origin
		
	if update_rotation && update_scale:
		to.basis = from.basis
	elif update_rotation || update_scale:
		var kept_scale := from.basis if update_scale else to.basis.orthonormalized()
		var kept_rotation := from.basis if update_rotation else to.basis.orthonormalized()
		to.basis = Basis.from_euler(kept_rotation.get_euler()) * Basis.from_scale(kept_scale.get_scale())
	return to
