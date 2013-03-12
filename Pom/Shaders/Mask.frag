#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_texCoord;
uniform sampler2D u_texture;
uniform sampler2D u_colorRampTexture;

uniform float u_time;

uniform int u_flag;

void main()
{
	if(u_flag == 1) {
		/*
		// Mask with a texture Effect
		vec4 normalColor = texture2D(u_texture, v_texCoord).rgba;
	
		float rampedR = texture2D(u_colorRampTexture, vec2(normalColor.r, 0)).r * normalColor.a;
		float rampedG = texture2D(u_colorRampTexture, vec2(normalColor.g, 0)).g * normalColor.a;
		float rampedB = texture2D(u_colorRampTexture, vec2(normalColor.b, 0)).b * normalColor.a;
	
		gl_FragColor = vec4(rampedR, rampedG, rampedB, normalColor.a);
		*/	
	
		vec4 normalColor = texture2D(u_texture, v_texCoord).rgba;
		vec2 onePixel = vec2(1.0 / 480.0, 1.0 / 320.0);
	
		vec2 texCoord = v_texCoord;
	
		vec4 color;
		color.rgb = vec3(0.5);
		color.rgb -= texture2D(u_texture, texCoord - onePixel).rgb * 5.0;
		color.rgb += texture2D(u_texture, texCoord + onePixel).rgb * 5.0;
	
		color.rgb = vec3((color.r + color.g + color.b) * normalColor.a / 3.0);
	
		float factor = sin(u_time);
	
		// Gradient over Time
		//float of = factor;
		//float af = 1.0 - factor;

		float of = 0.3;
		float af = 0.7;

		float rampedR = normalColor.r * of + color.r * af;
		float rampedG = normalColor.g * of + color.g * af;
		float rampedB = normalColor.b * of + color.b * af;

		//gl_FragColor = vec4(color.rgb, normalColor.a);// Carving
	
		gl_FragColor = vec4(rampedR, rampedG, rampedB, normalColor.a);
	

	}else {
		gl_FragColor = texture2D(u_texture, v_texCoord).rgba;	
		
	}
}




