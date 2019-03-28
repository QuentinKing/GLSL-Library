#version 150

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform vec3 spectrum;
uniform mat4 mvp;
uniform mat4 model;
uniform mat4 view;

uniform vec3 lightPosition;

uniform vec4 baseColor;  // Base color of the object (Albedo)
uniform float kA;        // Ambient intensity
uniform float kD;        // Diffuse intensity
uniform float kS;        // Specular intensity
uniform float shininess; // Shininess power

in vec4 a_position;
in vec3 a_normal;
in vec2 a_texcoord;

out VertexData
{
    vec4 v_position;
    vec3 v_normal;
    vec2 v_texcoord;
    vec4 v_color;
} outData;

void main(void)
{
    mat4 mv = model * view;

    vec3 worldPosition = (mv * a_position).xyz;
    vec3 worldNormal = normalize(mv * vec4(a_normal, 0.0)).xyz;
    vec3 cameraPosition = (mv * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
    vec3 toLight = normalize(lightPosition - worldPosition);
    
    // Diffuse lighting calculation
    float nl = max(0.0, dot(worldNormal, toLight));
    
    // Specular lighting calculation
    float sl = max(0.0, dot(normalize(cameraPosition-worldPosition), reflect(worldNormal, toLight)));
    sl = pow(sl, shininess);

    gl_Position = mvp * a_position;

    outData.v_position = a_position;
    outData.v_normal = a_normal;
    outData.v_texcoord = a_texcoord;
    outData.v_color = (kA + (kD * nl) + (kS * sl)) * baseColor;
}
