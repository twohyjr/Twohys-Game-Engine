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
    float shininess;
    float specularIntensity;
    float visibility;
    float3 skyColor;
    float4 worldPosition;
    float3 toCameraVector;
};

struct ModelConstants{
    float4x4 modelMatrix;
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
    float4x4 inverseViewMatrix;
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
    
    //Vertex Position Descriptors
    float4x4 transformationMatrix = modelConstants.modelMatrix;
    float4 worldPosition = transformationMatrix * float4(vIn.position, 1.0);
    vOut.position = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * worldPosition;
    vOut.worldPosition = worldPosition;
    vOut.surfaceNormal = (transformationMatrix * float4(vIn.normal, 0.0)).xyz;
    vOut.toCameraVector = (sceneConstants.inverseViewMatrix * float4(0.0,0.0,0.0,1.0)).xyz - worldPosition.xyz;
    
    //Coloring
    vOut.shininess = modelConstants.shininess;
    vOut.color = modelConstants.materialColor;
    vOut.textureCoordinate = vIn.textureCoordinate;
    vOut.specularIntensity = modelConstants.specularIntensity;
    vOut.skyColor = sceneConstants.skyColor;
    
    //FOG
    float distance = length(vOut.position.xyz);
    float visibility = exp(-pow((distance * sceneConstants.fogDensity),sceneConstants.fogGradient));
    visibility = clamp(visibility, 0.0, 1.0);
    vOut.visibility = visibility;
    
    return vOut;
}

vertex VertexOut instanceVertexShader(const VertexIn vIn [[ stage_in ]],
                                      constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                      constant ModelConstants *modelConstants [[ buffer(2) ]],
                                      uint instanceID [[ instance_id ]]){
    
    VertexOut vOut;
    ModelConstants constants = modelConstants[instanceID];
    float4 worldPosition = constants.modelMatrix * float4(vIn.position,1);
    vOut.position = sceneConstants.projectionMatrix *  worldPosition;
    
    float distance = length(vOut.position.xyz);
    float visibility = exp(-pow((distance * sceneConstants.fogDensity),sceneConstants.fogGradient));
    visibility = clamp(visibility, 0.0, 1.0);
    
    vOut.visibility = visibility;
    
    vOut.textureCoordinate = vIn.textureCoordinate;
    vOut.surfaceNormal = constants.normalMatrix * vIn.normal;
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
    float3 toLightVector = light.position - vIn.worldPosition.xyz;
    
    float3 unitNormal = normalize(vIn.surfaceNormal);
    float3 unitLightVector = normalize(toLightVector);
    
    float3 ambient = light.color * light.ambientIntensity;
    
    float nDot1 = dot(unitNormal, unitLightVector);
    float brightness = max(nDot1, 0.0);
    float3 diffuse = brightness * light.color * light.brightness;
    
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

fragment half4 texturedFragmentShader(VertexOut vIn [[ stage_in ]],
                                          sampler sampler2d [[ sampler(0) ]],
                                          texture2d<float> texture [[ texture(0) ]],
                                          constant Light &light [[ buffer(1) ]]){
    float4 color = texture.sample(sampler2d, vIn.textureCoordinate);
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

kernel void shader(device float4 &color [[buffer(0)]],
                   sampler sampler2d [[ sampler(0) ]],
                   texture2d<float> texture [[ texture(0) ]],
                   uint2 id [[thread_position_in_grid]]){
    
    color = float4(id.x, id.y, 99,99);
}



