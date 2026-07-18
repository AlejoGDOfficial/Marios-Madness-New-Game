#pragma header

uniform float threshold;

void main()
{
    vec2 uv = openfl_TextureCoordv;

    vec4 color = flixel_texture2D(bitmap, uv);

    if (dot(color.rgb, vec3(0.3, 0.59, 0.11)) < threshold)
    {
        color.rgb = vec3(0);
    }

    gl_FragColor = color;
}