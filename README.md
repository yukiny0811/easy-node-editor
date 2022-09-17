# EasyNodeEditor

[![CI](https://github.com/yukiny0811/easy-node-editor/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/yukiny0811/easy-node-editor/actions/workflows/swift.yml)
[![Release](https://img.shields.io/github/v/release/yukiny0811/easy-node-editor)](https://github.com/yukiny0811/easy-node-editor/releases/latest)
[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2Feasy-node-editor%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/yukiny0811/easy-node-editor)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2Feasy-node-editor%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/yukiny0811/easy-node-editor)
[![License](https://img.shields.io/github/license/yukiny0811/easy-node-editor)](https://github.com/yukiny0811/easy-node-editor/blob/main/LICENSE)

**Still in alpha stage of development!**

## Demo

![GIF 2022-09-17 at 8 27 39 PM](https://user-images.githubusercontent.com/28947703/190854305-3e2bb603-fdab-4f53-b7f2-dd587ad39537.gif)

## Usage1 - Standard output node

### Step 1. Create your node
Create a class, and inherit it from NodeModelBase class.
```.swift
class YourOutputNode: NodeModelBase {
}
```

### Step 2. Create Outputs
Create output variables.     
Put ```@Output``` for output variables.    
Make sure you put ```@objc``` wrapper to all your output variables.    
There are no restrictions on the naming of the variables. Name the variables whatever you want, and the library will automatically use that name to display in the node.    
```.swift
class YourOutputNode: NodeModelBase {
    @objc @Output var output: Int = 3
}
```

### Step 3. Register your node
Register your node when you instanciate EasyNodeEditor View.
```.swift
struct ContentView: View {
    var body: some View {
        EasyNodeEditor(nodeTypes: [YourOutputNode.self])
    }
}
```

**This is it!**    
The EasyNodeEditor Library will create a node like this.

<img width="286" alt="image" src="https://user-images.githubusercontent.com/28947703/190853209-7b8a1844-8bc8-4e20-8bfe-917cc88a2709.png">

## Usage2 - Standard input and output node

### Step 1. Create your node
Create a class, and inherit it from NodeModelBase class.
```.swift
class YourIONode: NodeModelBase {
}
```

### Step 2. Create Inputs and Outputs
Create inputs and/or outputs.    
Put ```@Input``` for input variables, and ```@Output``` for output variables.    
Make sure you put ```@objc``` wrapper to all your input and output variables.     
There are no restrictions on the naming of the variables. Name the variables whatever you want, and the library will automatically use that name to display in the node.    
```.swift
class YourIONode: NodeModelBase {
    @objc @Input var input: Int = 0
    @objc @Output var output: Int = 0
}
```

### Step 3. Define what happens when input value changes
Override ```processOnChange()``` function, and define your process.    
Don't change input value inside ```processOnChange()```. It will start infinite loop.    
```.swift
class YourIONode: NodeModelBase {
    @objc @Input var input: Int = 0
    @objc @Output var output: Int = 0
    override func processOnChange() {
        output = input * 5
    }
}
```

### Step 4. Register your node
Register your node when you instanciate EasyNodeEditor View.
```.swift
struct ContentView: View {
    var body: some View {
        EasyNodeEditor(nodeTypes: [YourOutputNode.self, YoutIONode.self])
    }
}
```

**Very easy!!**    
The EasyNodeEditor Library will create a node like this.

<img width="319" alt="image" src="https://user-images.githubusercontent.com/28947703/190853336-2c347cb7-9528-483f-acde-6231a0b487f9.png">

## Usage 3 - Standard display node

### Step 1. Create your node
Create a class, and inherit it from NodeModelBase class.
```.swift
class YourDisplayNode: NodeModelBase {
}
```

### Step 2. Create Inputs
Create inputs.  
Put ```@Input``` for input variables.    
Make sure you put ```@objc``` wrapper to all your input variables.     
There are no restrictions on the naming of the variables. Name the variables whatever you want, and the library will automatically use that name to display in the node.    
```.swift
class YourDisplayNode: NodeModelBase {
    @objc @Input var input: Int = 0
}
```

### Step3. Create View
Override ```middleContent()``` function, and define your View.
```.swift
class YourDisplayNode: NodeModelBase {
    @objc @Input var input: Int = 0
    override func middleContent() -> AnyView {
        return AnyView(
            Group {
                Text("number is now -> \(input)")
            }
        )
    }
}
```

### Step 4. Register your node
Register your node when you instanciate EasyNodeEditor View.
```.swift
struct ContentView: View {
    var body: some View {
        EasyNodeEditor(nodeTypes: [YourOutputNode.self, YoutIONode.self, YourDisplayNode.self])
    }
}
```

**Amazing!!**    
The EasyNodeEditor Library will create a node like this.

<img width="251" alt="image" src="https://user-images.githubusercontent.com/28947703/190853699-0bb3b421-fafb-45ea-a156-4bbec6080ace.png">

## Usage 4 - Standard Interactive Node

I assume you have read Usage 1 ~ 3 here.    
For interactive nodes, EasyNodeEditor provides ```@Middle``` property wrapper.    
Whenever the value of the variables with ```@Input``` or ```@Middle``` changes, ```processOnChange()``` function will fire.    
If you need a binding object for interaction, create a class which inherits ```ObservableObject``` and define a ```@Published``` variable inside. Variables defined directly inside your node class will not be bindable.    
After finished making, register your node as usual.    
```.swift
class YourInteractiveNodeSubModel: ObservableObject {
    @Published var sliderValue: Double = 0.0
}
class YourInteractiveNode: NodeModelBase {
    @objc @Input var input: Int = 0
    @ObservedObject var subModel = YourInteractiveNodeSubModel()
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
```

**Simple!!**    
The EasyNodeEditor Library will create a node like this.

![GIF 2022-09-17 at 8 21 30 PM](https://user-images.githubusercontent.com/28947703/190854074-28cd9699-70a1-4dca-b480-6f69f9cb43f6.gif)

## Full Sample Code

```.swift
import SwiftUI
import EasyNodeEditor

struct ContentView: View {
    var body: some View {
        EasyNodeEditor(nodeTypes: [YourOutputNode.self, YourIONode.self, YourDisplayNode.self, YourInteractiveNode.self])
    }
}

class YourOutputNode: NodeModelBase {
    @objc @Output var output: Int = 3
}

class YourIONode: NodeModelBase {
    @objc @Input var input: Int = 0
    @objc @Output var output: Int = 0
    override func processOnChange() {
        output = input * 5
    }
}

class YourDisplayNode: NodeModelBase {
    @objc @Input var input: Int = 0
    override func middleContent() -> AnyView {
        return AnyView(
            Group {
                Text("number is now -> \(input)")
            }
        )
    }
}

class YourInteractiveNodeSubModel: ObservableObject {
    @Published var sliderValue: Double = 0.0
}
class YourInteractiveNode: NodeModelBase {
    @objc @Input var input: Int = 0
    @ObservedObject var subModel = YourInteractiveNodeSubModel()
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
```
