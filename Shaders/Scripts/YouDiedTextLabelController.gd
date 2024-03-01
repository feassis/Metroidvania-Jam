extends RichTextLabel

func SetOpacity(opacity):
	material.set_shader_parameter("opacity", opacity)
