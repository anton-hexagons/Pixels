//
//  PIXContent.swift
//  Pixels
//
//  Created by Hexagons on 2018-07-26.
//  Open Source - MIT License
//


open class PIXContent: PIX, PIXOutIO {
    
    var pixOutPathList: [PIX.OutPath] = []
    var connectedOut: Bool { return !pixOutPathList.isEmpty }
    
    override public init() {
        super.init()
    }
    
}
