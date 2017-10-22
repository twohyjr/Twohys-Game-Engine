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
        self.clearColor = MTLClearColor(red: 0.33, green: 0.78, blue: 0.49, alpha: 1.0)
        self.renderer = Renderer(device: self.device!, mtkView: self)
        self.delegate = renderer

    }
    
    
}
