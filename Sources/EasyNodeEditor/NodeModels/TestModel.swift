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
    public override func processOnChange() {
        output = input + count
    }
}

