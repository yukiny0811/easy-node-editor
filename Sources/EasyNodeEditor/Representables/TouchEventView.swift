//
//  File.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import SwiftUI

struct TouchEventView: NSViewRepresentable {
    typealias NSViewType = NSTouchEventView
    let view: NSTouchEventView
    func makeNSView(context: Context) -> NSViewType {
        return view
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
    }
}
