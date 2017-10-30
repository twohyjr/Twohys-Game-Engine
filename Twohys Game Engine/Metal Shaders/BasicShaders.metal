#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float3 normal [[ attribute(2) ]];
    float2 textureCoordinate [[ attribute(3) ]];
};

struct VertexOut{
    float4 position [[ position ]];
    float4 color;
    float2 textureCoordinate;
    float3 surfaceNormal;
    float3 eyePosition;
    float shininess;
    float specularIntensity;
};

struct ModelConstants{
    float4x4 modelViewMatrix;
    float3x3 normalMatrix;
    float shininess;
    float specularIntensity;
};

struct SceneConstants{
    float4x4 projectionMatrix;
};

struct Light{
    float3 color;
    float ambientIntensity;
    float3 direction;
    float diffuseIntensity;
    float brightness;
};

vertex VertexOut vertexShader(const VertexIn vIn [[ stage_in ]],
                              constant SceneConstants &sceneConstants [[ buffer(1) ]],
                              constant ModelConstants &modelConstants [[ buffer(2) ]]){
    
    VertexOut vOut;
    float4 worldPosition = modelConstants.modelViewMatrix * float4(vIn.position,1);
    vOut.position = sceneConstants.projectionMatrix *  worldPosition;
    vOut.color = vIn.color;
    vOut.textureCoordinate = vIn.textureCoordinate;
    vOut.surfaceNormal = modelConstants.normalMatrix * vIn.normal;
    vOut.eyePosition = worldPosition.xyz;
    vOut.shininess = modelConstants.shininess;
    vOut.specularIntensity = modelConstants.specularIntensity;

    
    return vOut;
}

vertex VertexOut instanceVertexShader(const VertexIn vIn [[ stage_in ]],
                                      constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                      constant ModelConstants *modelConstants [[ buffer(2) ]],
                                      uint instanceID [[ instance_id ]]){
    
    VertexOut vOut;
    ModelConstants constants = modelConstants[instanceID];
    vOut.position = sceneConstants.projectionMatrix *  constants.modelViewMatrix * float4(vIn.position,1);
    vOut.color = vIn.color;
    vOut.textureCoordinate = vIn.textureCoordinate;
    return vOut;
}

fragment half4 fragmentShader(VertexOut vIn [[ stage_in ]],
                               constant Light &light [[ buffer(1) ]]){
    float4 color = vIn.color;
    float3 unitNormal = normalize(vIn.surfaceNormal);
    float3 unitEye = normalize(vIn.eyePosition);
    
    //Ambient Color
    float3 ambientColor = light.color * light.ambientIntensity;
    
    //Diffuse Color
    float diffuseFactor = saturate(-dot(unitNormal, light.direction));
    float3 diffuseColor = light.color * light.diffuseIntensity * diffuseFactor * light.brightness;
    
    //Specular Color
    float3 reflection = reflect(light.direction, unitNormal);
    float specularFactor = pow(saturate(-dot(reflection, unitEye)), vIn.shininess);
    float3 specularColor = light.color * vIn.specularIntensity * specularFactor;
    
    color = color * float4(ambientColor + diffuseColor + specularColor, 1);
    return half4(color.x, color.y, color.z, 1);
}

fragment half4 texturedFragmentShader(VertexOut vIn [[ stage_in ]],
                                          sampler sampler2d [[ sampler(0) ]],
                                          texture2d<float> texture [[ texture(0) ]],
                                          constant Light &light [[ buffer(1) ]]){
    float4 color = texture.sample(sampler2d, vIn.textureCoordinate);
    float3 unitNormal = normalize(vIn.surfaceNormal);
    float3 unitEye = normalize(vIn.eyePosition);

    //Ambient Color
    float3 ambientColor = light.color * light.ambientIntensity;
    
    //Diffuse Color
    float diffuseFactor = saturate(-dot(unitNormal, light.direction));
    float3 diffuseColor = light.color * light.diffuseIntensity * diffuseFactor;
    
    //Specular Color
    float3 reflection = reflect(light.direction, unitNormal);
    float specularFactor = pow(saturate(-dot(reflection, unitEye)), vIn.shininess);
    float3 specularColor = light.color * vIn.specularIntensity * specularFactor;
    
    color = color * float4(ambientColor + diffuseColor + specularColor, 1);
    return half4(color.x, color.y, color.z, 1);
}

