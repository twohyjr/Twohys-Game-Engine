//
//  Main View.swift
//  Twohys Game Engine
//
//  Created by Rick Twohy on 10/14/17.
//  Copyright © 2017 Rick Twohy. All rights reserved.
//

import MetalKit

class MainView: MTKView {
    
    var renderer: Renderer!

    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        self.colorPixelFormat = .bgra8Unorm
        self.clearColor = MTLClearColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        self.depthStencilPixelFormat = .depth32Float
        self.renderer = Renderer(device: self.device!, mtkView: self)
        renderer.updateTrackingArea(view: self)
        self.delegate = renderer

    }
    
    override var acceptsFirstResponder: Bool { return true }
    
    override func mouseMoved(with event: NSEvent) {
        let x: Float = Float(event.locationInWindow.x)
        let y: Float = Float(event.locationInWindow.y)
        InputHandler.setMousePosition(position: float2(x,y))
        
        //Swift.print("Mouse Position: \(x), \(y)")
    }
    
    override func keyDown(with event: NSEvent) {
        InputHandler.setKeyPressed(key: event.keyCode, isOn: true)
    }
    
    override func keyUp(with event: NSEvent) {
        InputHandler.setKeyPressed(key: event.keyCode, isOn: false)
    }
}
