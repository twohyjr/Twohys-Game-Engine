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
    float visibility;
    float3 skyColor;
};

struct ModelConstants{
    float4x4 modelViewMatrix;
    float3x3 normalMatrix;
    float shininess;
    float specularIntensity;
    float4 materialColor;
};

struct SceneConstants{
    float4x4 projectionMatrix;
    float3 skyColor;
    float fogDensity;
    float fogGradient;
    float4x4 viewMatrix;
};


struct Light{
    float3 position;
    float3 color;
    float brightness;
    float ambientIntensity;
    float diffuseIntensity;
};

vertex VertexOut vertexShader(const VertexIn vIn [[ stage_in ]],
                              constant SceneConstants &sceneConstants [[ buffer(1) ]],
                              constant ModelConstants &modelConstants [[ buffer(2) ]]){
    
    VertexOut vOut;
    float4 worldPosition = modelConstants.modelViewMatrix * float4(vIn.position,1);
    vOut.position = sceneConstants.projectionMatrix *  worldPosition;
    
    float distance = length(vOut.position.xyz);
    float visibility = exp(-pow((distance * sceneConstants.fogDensity),sceneConstants.fogGradient));
    visibility = clamp(visibility, 0.0, 1.0);
    
    vOut.visibility = visibility;
    
    vOut.textureCoordinate = vIn.textureCoordinate;
    
    vOut.surfaceNormal = (sceneConstants.viewMatrix * float4(vIn.normal,0)).xyz;
//    vOut.surfaceNormal = worldPosition.xyz * vIn.normal;
    vOut.eyePosition = worldPosition.xyz;
    vOut.shininess = modelConstants.shininess;
    vOut.specularIntensity = modelConstants.specularIntensity;
    vOut.skyColor = sceneConstants.skyColor;
    
    if(vIn.color.x == 0 && vIn.color.y == 0 && vIn.color.z == 0){
        vOut.color = modelConstants.materialColor;
    }else{
        vOut.color = vIn.color;
    }

    return vOut;
}

vertex VertexOut instanceVertexShader(const VertexIn vIn [[ stage_in ]],
                                      constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                      constant ModelConstants *modelConstants [[ buffer(2) ]],
                                      uint instanceID [[ instance_id ]]){
    
    VertexOut vOut;
    ModelConstants constants = modelConstants[instanceID];
    float4 worldPosition = constants.modelViewMatrix * float4(vIn.position,1);
    vOut.position = sceneConstants.projectionMatrix *  worldPosition;
    
    float distance = length(vOut.position.xyz);
    float visibility = exp(-pow((distance * sceneConstants.fogDensity),sceneConstants.fogGradient));
    visibility = clamp(visibility, 0.0, 1.0);
    
    vOut.visibility = visibility;
    
    vOut.textureCoordinate = vIn.textureCoordinate;
    vOut.surfaceNormal = constants.normalMatrix * vIn.normal;
    //    vOut.surfaceNormal = worldPosition.xyz * vIn.normal;
    vOut.eyePosition = worldPosition.xyz;
    vOut.shininess = constants.shininess;
    vOut.specularIntensity = constants.specularIntensity;
    vOut.skyColor = sceneConstants.skyColor;
    if(vIn.color.x == 0 && vIn.color.y == 0 && vIn.color.z == 0){
        vOut.color = constants.materialColor;
    }else{
        vOut.color = vIn.color;
    }
    
    return vOut;
}

fragment half4 fragmentShader(VertexOut vIn [[ stage_in ]],
                               constant Light &light [[ buffer(1) ]]){
    float4 color = vIn.color;
    float visibility = vIn.visibility;
    float3 unitNormal = normalize(vIn.surfaceNormal);
    float3 unitEye = normalize(vIn.eyePosition);
    float3 lightPosition = light.position;
    
    //Ambient Color
    float3 ambientColor = light.color * light.ambientIntensity;
    
    //Diffuse Color
    float diffuseFactor = saturate(-dot(unitNormal, lightPosition));
    float3 diffuseColor = light.color * light.diffuseIntensity * diffuseFactor;
    
    //Specular Color
    float3 reflection = reflect(lightPosition, unitNormal);
    float specularFactor = pow(saturate(-dot(reflection, unitEye)), vIn.shininess);
    float3 specularColor = light.color * vIn.specularIntensity * specularFactor;
    
    if (color.a == 0.0){
        discard_fragment();
    }

    color = color * float4(ambientColor + diffuseColor + specularColor, 1)  * 1.5;
    color = mix(float4(vIn.skyColor, 1), color, visibility);
    
    
    return half4(color.x, color.y, color.z, 1);
}

fragment half4 texturedFragmentShader(VertexOut vIn [[ stage_in ]],
                                          sampler sampler2d [[ sampler(0) ]],
                                          texture2d<float> texture [[ texture(0) ]],
                                          constant Light &light [[ buffer(1) ]]){
    float4 color = texture.sample(sampler2d, vIn.textureCoordinate);
    float visibility = vIn.visibility;
    float3 unitNormal = normalize(vIn.surfaceNormal);
    float3 unitEye = normalize(vIn.eyePosition);
    
    //Ambient Color
    float3 ambientColor = light.color * light.ambientIntensity;
    
    //Diffuse Color
    float diffuseFactor = saturate(-dot(unitNormal, light.position));
    float3 diffuseColor = light.color * light.diffuseIntensity * diffuseFactor;
    
    //Specular Color
    float3 reflection = reflect(light.position, unitNormal);
    float specularFactor = pow(saturate(-dot(reflection, unitEye)), vIn.shininess);
    float3 specularColor = light.color * vIn.specularIntensity * specularFactor;
    
    if (color.a == 0.0){
        discard_fragment();
    }
    
    color = color * float4(ambientColor + diffuseColor + specularColor, 1)  * light.brightness;
    color = mix(float4(vIn.skyColor, 1), color, visibility);
    

    
    return half4(color.x, color.y, color.z, 1);
}




