//
//  PIXUIs.swift
//  PixelKit
//
//  Created by Anton Heestand on 2019-10-04.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import RenderKit

@available(macOS 10.15, *)
public protocol PIXUI: NODEUI {
    var pix: PIX { get }
}
