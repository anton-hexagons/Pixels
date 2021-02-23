//
//  ReorderPIX.swift
//  PixelKit
//
//  Created by Anton Heestand on 2018-09-07.
//  Open Source - MIT License
//

import Foundation
import RenderKit
import CoreGraphics

final public class ReorderPIX: PIXMergerEffect, PIXViewable, ObservableObject {
    
    override public var shaderName: String { return "effectMergerReorderPIX" }
    
    // MARK: - Public Properties
    
    public enum Input: String, Enumable {
        case first = "First"
        case second = "Second"
        public var index: Int {
            switch self {
            case .first:
                return 0
            case .second:
                return 1
            }
        }
        public var names: [String] {
            Self.allCases.map(\.rawValue)
        }
    }
    @LiveEnum(name: "Red Input") public var redInput: Input = .first
    @LiveEnum(name: "Green Input") public var greenInput: Input = .first
    @LiveEnum(name: "Blue Input") public var blueInput: Input = .first
    @LiveEnum(name: "Alpha Input") public var alphaInput: Input = .first
    
    public enum RawChannel {
        case red
        case green
        case blue
        case alpha
    }
    public enum Channel: String, Enumable {
        case red = "Red"
        case green = "Greeb"
        case blue = "Blue"
        case alpha = "Alpha"
        case zero = "Zero"
        case one = "One"
        case luma = "Luma"
        public var index: Int {
            switch self {
            case .red: return 0
            case .green: return 1
            case .blue: return 2
            case .alpha: return 3
            case .zero: return 4
            case .one: return 5
            case .luma: return 6
            }
        }
        public var names: [String] {
            Self.allCases.map(\.rawValue)
        }
    }
    @LiveEnum(name: "Red Channel") public var redChannel: Channel = .red
    @LiveEnum(name: "Green Channel") public var greenChannel: Channel = .green
    @LiveEnum(name: "Blue Channel") public var blueChannel: Channel = .blue
    @LiveEnum(name: "Alpha Channel") public var alphaChannel: Channel = .alpha
    
    @LiveBool(name: "Premultiply") public var premultiply: Bool = true
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        [_redInput, _redChannel, _greenInput, _greenChannel, _blueInput, _blueChannel, _alphaInput, _alphaChannel, _premultiply] + super.liveList
    }
    
    public override var uniforms: [CGFloat] {
        var vals: [CGFloat] = []
        vals.append(contentsOf: [redInput == .first ? 0 : 1, CGFloat(redChannel.index)])
        vals.append(contentsOf: [greenInput == .first ? 0 : 1, CGFloat(greenChannel.index)])
        vals.append(contentsOf: [blueInput == .first ? 0 : 1, CGFloat(blueChannel.index)])
        vals.append(contentsOf: [alphaInput == .first ? 0 : 1, CGFloat(alphaChannel.index)])
        vals.append(premultiply ? 1 : 0)
        vals.append(CGFloat(placement.index))
        return vals
    }
    
    public required init() {
        super.init(name: "Reorder", typeName: "pix-effect-merger-reorder")
        premultiply = false
    }
    
}

public extension NODEOut {
    
    func pixReorder(from channel: ReorderPIX.Channel, to rawChannel: ReorderPIX.RawChannel, pix: () -> (PIX & NODEOut)) -> ReorderPIX {
        pixReorder(pix: pix(), from: channel, to: rawChannel)
    }
    func pixReorder(pix: PIX & NODEOut, from channel: ReorderPIX.Channel, to rawChannel: ReorderPIX.RawChannel) -> ReorderPIX {
        let reorderPix = ReorderPIX()
        reorderPix.name = ":reorder:"
        reorderPix.inputA = self as? PIX & NODEOut
        reorderPix.inputB = pix
        switch rawChannel {
        case .red:
            reorderPix.redInput = .second
            reorderPix.redChannel = channel
        case .green:
            reorderPix.greenInput = .second
            reorderPix.greenChannel = channel
        case .blue:
            reorderPix.blueInput = .second
            reorderPix.blueChannel = channel
        case .alpha:
            reorderPix.alphaInput = .second
            reorderPix.alphaChannel = channel
        }
        return reorderPix
    }
    
    func pixReplace(_ rawChannel: ReorderPIX.RawChannel, with channel: ReorderPIX.Channel) -> ReorderPIX {
        let reorderPix = ReorderPIX()
        reorderPix.name = ":reorder:"
        reorderPix.inputA = self as? PIX & NODEOut
        reorderPix.inputB = self as? PIX & NODEOut
        switch rawChannel {
        case .red:
            reorderPix.redChannel = channel
        case .green:
            reorderPix.greenChannel = channel
        case .blue:
            reorderPix.blueChannel = channel
        case .alpha:
            reorderPix.alphaChannel = channel
        }
        return reorderPix
    }
    
}
