//
//  DelayPIX.swift
//  Pixels
//
//  Created by Anton Heestand on 2018-09-23.
//  Open Source - MIT License
//
import CoreGraphics//x
import Metal

public class DelayPIX: PIXSingleEffect, PixelsCustomRenderDelegate {
    
    override open var shader: String { return "nilPIX" }
    
    // MARK: - Public Properties
    
//    public var delaySeconds: CGFloat = 1.0 { didSet { setNeedsRender() } }
    public var delayFrames: Int = 1 { didSet { setNeedsRender() } }
    
    // MARK: - Property Helpers
    
    var cachedTextures: [MTLTexture] = []
    
    public override required init() {
        super.init()
        customRenderActive = true
        customRenderDelegate = self
    }
    
    // MARK: Delay
    
    public func customRender(_ texture: MTLTexture, with commandBuffer: MTLCommandBuffer) -> MTLTexture? {
        guard delayFrames > 0 else { return texture }
        cachedTextures.append(texture)
        if cachedTextures.count > delayFrames {
            cachedTextures.remove(at: 0)
        }
        return cachedTextures.first!
    }
    
}

public extension PIXOut {
    
    func _delay(frames: Int) -> DelayPIX {
        let delayPix = DelayPIX()
        delayPix.name = ":delay:"
        delayPix.inPix = self as? PIX & PIXOut
        delayPix.delayFrames = frames
        return delayPix
    }
    
}
