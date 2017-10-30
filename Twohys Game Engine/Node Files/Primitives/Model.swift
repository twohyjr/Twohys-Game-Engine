import MetalKit
import SceneKit

class Model: Node{
    
    var _renderPipelineState: MTLRenderPipelineState!
    
    var modelConstants = ModelConstants()
    
    var meshes: [AnyObject]?
    
    var texture: MTLTexture?
    
    var vertexDescriptor: MTLVertexDescriptor{
        let vertexDescriptor = MTLVertexDescriptor()
        
        //Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        //Color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.size
        
        //Normal
        vertexDescriptor.attributes[2].format = .float3
        vertexDescriptor.attributes[2].bufferIndex = 0
        vertexDescriptor.attributes[2].offset = MemoryLayout<float3>.size + MemoryLayout<float4>.size
        
        //Texture Coordinate
        vertexDescriptor.attributes[3].format = .float2
        vertexDescriptor.attributes[3].bufferIndex = 0
        vertexDescriptor.attributes[3].offset = MemoryLayout<float3>.stride + MemoryLayout<float4>.stride + MemoryLayout<float3>.stride
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        return vertexDescriptor
    }
    
    init(device: MTLDevice, modelName: String, textureName: String){
        super.init()
        buildModelMeshes(device: device, modelName: modelName)
        
        if let texture = setTexture(device: device, imageName: textureName){
            self.texture = texture
            _renderPipelineState = FlashPipelineStateProvider.getFlashPipelineState(flashPipelineStateType: FlashPipelineStateType.TEXTUREABLE)
        }else{
            _renderPipelineState = FlashPipelineStateProvider.getFlashPipelineState(flashPipelineStateType: FlashPipelineStateType.RENDERABLE)
        }
    }
    
    func buildModelMeshes(device: MTLDevice, modelName: String){
        let assetURL = Bundle.main.url(forResource: modelName, withExtension: "obj")
        
        let assetVertexDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        
        let position = assetVertexDescriptor.attributes[0] as! MDLVertexAttribute
        position.name = MDLVertexAttributePosition
        assetVertexDescriptor.attributes[0] = position
        
        let color = assetVertexDescriptor.attributes[1] as! MDLVertexAttribute
        color.name = MDLVertexAttributeColor
        assetVertexDescriptor.attributes[1] = color
        
        let textureCoordiantes = assetVertexDescriptor.attributes[2] as! MDLVertexAttribute
        textureCoordiantes.name = MDLVertexAttributeTextureCoordinate
        assetVertexDescriptor.attributes[2] = textureCoordiantes
        
        let normals = assetVertexDescriptor.attributes[3] as! MDLVertexAttribute
        normals.name = MDLVertexAttributeNormal
        assetVertexDescriptor.attributes[3] = normals
  
        let bufferAllocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: assetURL!, vertexDescriptor: assetVertexDescriptor, bufferAllocator: bufferAllocator)
        
        do{
            meshes = try MTKMesh.newMeshes(asset: asset, device: device).metalKitMeshes
        }catch let error as NSError{
            print(error)
        }
    }
}

extension Model: Renderable{
    func draw(renderCommandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        renderCommandEncoder.setRenderPipelineState(_renderPipelineState)
        
        modelConstants.modelViewMatrix = modelViewMatrix
        modelConstants.normalMatrix = modelViewMatrix.upperLeftMatrix()
        modelConstants.shininess = self.shininess
        modelConstants.specularIntensity = self.specularIntensity
        renderCommandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 2)
        
        if(texture != nil){
            renderCommandEncoder.setFragmentTexture(texture, index: 0)
        }

        guard let meshes = self.meshes as? [MTKMesh], meshes.count > 0 else { return }
  
        for mesh in meshes{
            
            let vertexBuffer = mesh.vertexBuffers[0]
            renderCommandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
            
            for submesh in mesh.submeshes{
                
                renderCommandEncoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                                     indexCount: submesh.indexCount,
                                                     indexType: submesh.indexType,
                                                     indexBuffer: submesh.indexBuffer.buffer,
                                                     indexBufferOffset: submesh.indexBuffer.offset)
            }
        }
    }
}

extension Model: Texturable{  }
