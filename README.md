# EasyNodeEditor

[![CI](https://github.com/yukiny0811/easy-node-editor/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/yukiny0811/easy-node-editor/actions/workflows/swift.yml)
[![Release](https://img.shields.io/github/v/release/yukiny0811/easy-node-editor)](https://github.com/yukiny0811/easy-node-editor/releases/latest)
[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2Feasy-node-editor%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/yukiny0811/easy-node-editor)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2Feasy-node-editor%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/yukiny0811/easy-node-editor)
[![License](https://img.shields.io/github/license/yukiny0811/easy-node-editor)](https://github.com/yukiny0811/easy-node-editor/blob/main/LICENSE)

```.swift
import SwiftUI
import EasyNodeEditor

struct ContentView: View {
    var body: some View {
        EasyNodeEditor(nodeTypes: [Output3Node.self, MultiplyNode.self, ShowNode.self])
    }
}

class Output3Node: NodeModelBase {
    @objc @Output var output: Int = 3
}

class MultiplyNodeSubModel: ObservableObject {
    @Published var sliderValue: Double = 0.0
}
class MultiplyNode: NodeModelBase {
    @objc @Input var input: Int = 0
    @ObservedObject var subModel = MultiplyNodeSubModel()
    @objc @Middle var count: Int = 0
    @objc @Output var output: Int = 0
    override func processOnChange() {
        output = input * count
    }
    override func middleContent() -> AnyView {
        return AnyView(
            Group {
                Slider(value: self.$subModel.sliderValue, in: 0...100, onEditingChanged: { changed in
                    self.count = Int(self.subModel.sliderValue)
                })
            }
            .frame(minWidth: 200, maxWidth: 200)
            .fixedSize()
        )
    }
}

class ShowNode: NodeModelBase {
    @objc @Input var myinput: Int = 0
    var showCount = 0
    override func processOnChange() {
        showCount = myinput
    }
    override func middleContent() -> AnyView {
        return AnyView(
            Group {
                Text("number is now -> \(showCount)")
            }
        )
    }
}
```
