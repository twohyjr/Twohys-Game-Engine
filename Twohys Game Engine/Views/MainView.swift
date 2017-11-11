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
    
    static let SKY_COLOR: float3 = float3(0.196078, 0.0705882, 0.152941)

    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        self.colorPixelFormat = .bgra8Unorm
        self.clearColor = MTLClearColor(red: Double(MainView.SKY_COLOR.x), green: Double(MainView.SKY_COLOR.y), blue: Double(MainView.SKY_COLOR.z), alpha: 1)
        self.depthStencilPixelFormat = .depth32Float
        self.renderer = Renderer(device: self.device!, mtkView: self)
        renderer.updateTrackingArea(view: self)
        self.delegate = renderer

    }
    
    override var acceptsFirstResponder: Bool { return true }
    
    
    //-------KEY EVENTS SECTION-------
    
    override func keyDown(with event: NSEvent) {
        InputHandler.setKeyPressed(key: event.keyCode, isOn: true)
    }
    
    override func keyUp(with event: NSEvent) {
        InputHandler.setKeyPressed(key: event.keyCode, isOn: false)
    }
    
    //-------END MOUSE EVENTS SECTION-------
    
    
    
    
    //-------MOUSE EVENTS SECTION-------
    
    override func mouseMoved(with event: NSEvent) {
        let x: Float = Float(event.locationInWindow.x)
        let y: Float = Float(event.locationInWindow.y)
//        MouseHandler.setOverallMousePosition(position: float2(x,y))
//        MouseHandler.setMousePositionChange(position: float2(Float(event.deltaX), Float(event.deltaY)))
    }
    
    override func scrollWheel(with event: NSEvent) {
        MouseHandler.scrollMouse(deltaY: Float(event.deltaY))
    }
    
    //Left Mouse Button Clicked
    override func mouseDown(with event: NSEvent) {
        MouseHandler.setMouseButtonPressed(button: event.buttonNumber, isOn: true)
    }
    
    override func mouseDragged(with event: NSEvent) {
        let overallLocation = float2(Float(event.locationInWindow.x), Float(event.locationInWindow.y))
        let deltaChange = float2(Float(event.deltaX), Float(event.deltaY))
        MouseHandler.setMousePositionChange(overallPosition: overallLocation, deltaPosition: deltaChange)

    }
    
    override func mouseUp(with event: NSEvent) {
        MouseHandler.setMouseButtonPressed(button: event.buttonNumber, isOn: false)
    }
    
    //Right Mouse Button Clicked
    override func rightMouseDown(with event: NSEvent) {
        MouseHandler.setMouseButtonPressed(button: event.buttonNumber, isOn: true)

    }
    
    override func rightMouseDragged(with event: NSEvent) {
        let overallLocation = float2(Float(event.locationInWindow.x), Float(event.locationInWindow.y))
        let deltaChange = float2(Float(event.deltaX), Float(event.deltaY))
        MouseHandler.setMousePositionChange(overallPosition: overallLocation, deltaPosition: deltaChange)
    }
    
    override func rightMouseUp(with event: NSEvent) {
        MouseHandler.setMouseButtonPressed(button: event.buttonNumber, isOn: false)
    }
    
    //Other Mouse Buttons Clicked
    override func otherMouseDown(with event: NSEvent) {
        //MouseHandler.setMouseButtonPressed(button: event.buttonNumber, isOn: true)
    }
    
    override func otherMouseDragged(with event: NSEvent){
        //MouseHandler.setMouseButtonPressed(button: event.buttonNumber, isOn: true)
    }
    
    override func otherMouseUp(with event: NSEvent) {
        //MouseHandler.setMouseButtonPressed(button: event.buttonNumber, isOn: false)
    }
    
    //-------END MOUSE EVENTS SECTION-------
    
    
    
    
    
    
    
    
    
}
