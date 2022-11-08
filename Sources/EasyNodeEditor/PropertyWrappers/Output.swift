//
//  Output.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import SwiftUI
import Combine

@propertyWrapper
public class Output<Value> : DynamicProperty{
    
    @Published private var value: Value
    
    public init (wrappedValue: Value) {
        _value = Published(wrappedValue: wrappedValue)
    }
    public var wrappedValue: Value {
        get {
            value
        }
        set {
            value = newValue
            print("wrapped value set")
            
        }
    }
    public var projectedValue: Binding<Value> {
        Binding(
            get: {
                self.value
            },
            set: {
                self.value = $0
                print("projected value set")
            }
        )
    }
    public static subscript<EnclosingSelf: ObservableObject>(
        _enclosingInstance object: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Output>
    ) -> Value {
        get {
            print("subscript get")
            return object[keyPath: storageKeyPath].value
        }
        set {
            print("output set ")
            object[keyPath: storageKeyPath].value = newValue
            let selfName = NSExpression(forKeyPath: wrappedKeyPath).keyPath
            guard let outputConnection = (object as? NodeModelBase)?.outputConnection[selfName] else {
                return
            }
            EasyNodeManager.shared.nodeModels[outputConnection.nodeID]!.setValue(newValue, forKey: outputConnection.inputName)
            EasyNodeManager.shared.objectWillChange.send()
        }
    }
}
