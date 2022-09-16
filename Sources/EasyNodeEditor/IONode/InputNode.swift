//
//  File.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import SwiftUI

struct InputNode: View {
    let idString: (nodeID: String, inputName: String)
    var body: some View {
        HStack {
            Rectangle()
                .fill(.yellow)
                .frame(width: 20, height: 20, alignment: .leading)
                .onHover{ hovering in
                    EasyNodeManager.shared.selectedInputID = self.idString
                }
            Text(idString.inputName)
        }
        .frame(width: 200, height: 30, alignment: .leading)
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
    }
}
