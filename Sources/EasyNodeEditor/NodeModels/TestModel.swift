//
//  TestModel.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import SwiftUI

public class TestModel: NodeModelBase {
    @objc @Input var input: Int = 0
    @objc @Middle var count: Int = 0
    @objc @Output var output: Int = 0
    override func processOnChange() {
        output = input + count
    }
    override func content() -> AnyView {
        return AnyView(
            VStack {
                InputNode(idString: (self.id, "input"))
                Button("+\(self.count)") {
                    self.count += 1
                }
                Text("Output -> \(self.output)")
                OutputNode(idString: (self.id, "output"))
            }
        )
    }
}
