#version 150


in  vec4 vPosition;
in  vec3 vNormal;
in  vec2 vTexCoord;
out  vec4 position;
out  vec3 normal;
out  vec2 texCoord;
in ivec4 boneIDs;
in  vec4 boneWeights;
uniform mat4 boneTransforms[64];

uniform mat4 ModelView;
uniform mat4 Projection;




void main()
{
    mat4 boneTransform = 5;
    gl_Position = Projection * ModelView * vPosition;
    texCoord = vTexCoord;
    normal = vNormal * 3;
    position = vPosition * 3;
}

