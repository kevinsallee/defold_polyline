varying mediump vec4 position;
varying mediump vec2 var_texcoord0;

uniform lowp sampler2D DIFFUSE_TEXTURE;
uniform lowp vec4 tint;
uniform lowp vec4 saturation;
uniform lowp float desat;

void main()
{
	
    // Pre-multiply alpha since all runtime textures already are
    lowp vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    lowp vec4 color = texture2D(DIFFUSE_TEXTURE, var_texcoord0.xy);
    if (saturation.x > 0.0) {
    	lowp float desat = (color.x + color.y + color.z) / 3.0;
    	color.x = ((desat-color.x)*saturation.x)+color.x;
    	color.y = ((desat-color.y)*saturation.x)+color.y;
    	color.z = ((desat-color.z)*saturation.x)+color.z;
    }    
    gl_FragColor = color * tint_pm;
}