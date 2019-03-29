#version 150

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform vec3 spectrum;

uniform sampler2D texture0;
uniform sampler2D texture1;
uniform sampler2D texture2;
uniform sampler2D texture3;
uniform sampler2D prevFrame;
uniform sampler2D prevPass;
uniform mat4 model;
uniform mat4 view;

uniform vec3 lightPosition;

uniform vec4 baseColor;  // Base color of the object (Albedo)
uniform float kA;        // Ambient intensity
uniform float kD;        // Diffuse intensity
uniform float kS;        // Specular intensity
uniform float shininess; // Shininess power

in VertexData
{
    vec4 v_position;
    vec3 v_normal;
    vec2 v_texcoord;
} inData;

out vec4 fragColor;

void main(void)
{
    mat4 mv = model * view;

    vec3 worldPosition = (mv * inData.v_position).xyz;
    vec3 worldNormal = normalize(mv * vec4(inData.v_normal, 0.0)).xyz;
    vec3 cameraPosition = (mv * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
    
    vec3 toLight = lightPosition - worldPosition;
    vec3 toViewer = cameraPosition - worldPosition;
    vec3 halfway = normalize(toLight + toViewer);
    vec3 lightDir = normalize(toLight);
    
    // Diffuse lighting calculation
    float nl = clamp(dot(worldNormal, lightDir), 0.0, 1.0);
    
    // Specular lighting calculation
    float sl = clamp(dot(worldNormal, halfway), 0.0, 1.0);
    sl = pow(sl, shininess);

    fragColor = (kA + (kD * nl) + (kS * sl)) * baseColor;
}
