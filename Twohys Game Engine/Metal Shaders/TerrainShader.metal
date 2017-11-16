#include <metal_stdlib>
using namespace metal;

struct VertexOut{
    float4 position [[ position ]];
    float4 color;
    float2 textureCoordinate;
    float3 surfaceNormal;
    float shininess;
    float specularIntensity;
    float visibility;
    float3 skyColor;
    float4 worldPosition;
    float3 toCameraVector;
};

struct Light{
    float3 position;
    float3 color;
    float brightness;
    float ambientIntensity;
    float diffuseIntensity;
};

fragment half4 multi_textured_terrain_fragment_shader(VertexOut vIn [[ stage_in ]],
                                      sampler sampler2d [[ sampler(0) ]],
                                      texture2d<float> texture1 [[ texture(0) ]],
                                      texture2d<float> texture2 [[ texture(1) ]],
                                      texture2d<float> texture3 [[ texture(2) ]],
                                      constant Light &light [[ buffer(1) ]]){
    float4 color = texture2.sample(sampler2d, vIn.textureCoordinate);
    float visibility = vIn.visibility;
    float3 toLightVector = light.position - vIn.worldPosition.xyz;
    
    float3 unitNormal = normalize(vIn.surfaceNormal);
    float3 unitLightVector = normalize(toLightVector);
    
    float3 ambient = light.color * light.ambientIntensity;
    
    float nDot1 = dot(unitNormal, unitLightVector);
    float brightness = max(nDot1, 0.0);
    float3 diffuse = brightness * light.color;
    
    float3 unitVectorToCamera = normalize(vIn.toCameraVector);
    float3 lightDirection = -unitLightVector;
    float3 reflectedLightDirection = reflect(lightDirection, unitNormal);
    
    float specularFactor = saturate(dot(reflectedLightDirection, unitVectorToCamera));
    specularFactor = max(specularFactor, 0.0);
    float dampedFactor = pow(specularFactor, vIn.shininess);
    float3 finalSpecular = dampedFactor * vIn.specularIntensity * light.color;
    
    color = color * (float4(diffuse, 1.0) + float4(finalSpecular, 1.0) + float4(ambient,1)) * light.brightness;
    
    if (color.a == 0.0){
        discard_fragment();
    }
    
    color = mix(float4(vIn.skyColor, 1), color, visibility);
    return half4(color.x, color.y, color.z, 1);
}




