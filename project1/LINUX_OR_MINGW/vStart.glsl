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
    mat4 boneTransform = boneWeights[0]*boneTransforms[boneIDs[0]] +
			boneWeights[1]*boneTransforms[boneIDs[1]] +
			boneWeights[2]*boneTransforms[boneIDs[2]] +
			boneWeights[3]*boneTransforms[boneIDs[3]];

    normal = boneTransform*vec4(vNormal,0.0);
    position = boneTransform*vPosition;


    gl_Position = Projection * ModelView * position;
    texCoord = vTexCoord;
}

