#version 150

//in  vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform vec4 LightPosition2;

uniform float Shininess;

in  vec4 position;
in  vec3 normal;
in  vec2 texCoord;

in  vec4 position2;
in  vec3 normal2;
in  vec2 texCoord2;

uniform sampler2D texture;

//don't need outs. Out is the gl fragcolour thing

void
main()
{

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * position).xyz;
    vec3 pos2 = (ModelView * position2).xyz;


    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - pos;
    vec3 Lvec2 = LightPosition2.xyz - pos2;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    vec3 L2 = normalize( Lvec2 );   // Direction to the light source
    vec3 E2 = normalize( -pos2 );   // Direction to the eye/camera
    vec3 H2 = normalize( L2 + E2 );  // Halfway vector

//------------------------------------------------------------------------------------------------------------------------------
//PART F: Brightness of Light

float magOfLvec = length(Lvec);

float distTerm = 1/(10 + 0.5*magOfLvec+ 0.5*magOfLvec*magOfLvec); //what contants should I use

float magOfLvec2 = length(Lvec2);

float distTerm2 = 1/(10 + 0.5*magOfLvec2+ 0.5*magOfLvec2*magOfLvec2); //what contants should I use


//--------------------------------------------------------------------------------------------------------------------------------


    // Transform vertex normal into eye coordinates (assumes scaling is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(normal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct + distTerm;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct + distTerm;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct*(20.0,20.0,20.0) + distTerm;
    
    if( dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 


//second light
    // Transform vertex normal into eye coordinates (assumes scaling is uniform across dimensions)
    vec3 N2 = normalize( (ModelView*vec4(normal2, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient2 = AmbientProduct + distTerm2;

    float Kd2 = max( dot(L2, N2), 0.0 );
    vec3  diffuse2 = Kd*DiffuseProduct + distTerm2;

    float Ks2 = pow( max(dot(N2, H2), 0.0), Shininess );
    vec3  specular2 = Ks2 * SpecularProduct*(20.0,20.0,20.0) + distTerm2;
    
    if( dot(L2, N2) < 0.0 ) {
	specular2 = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    gl_FragColor = vec4(globalAmbient  + ambient + diffuse + specular, 1.0)*texture2D( texture, texCoord * 2.0);
    gl_FragColor.a = 1.0;
}
