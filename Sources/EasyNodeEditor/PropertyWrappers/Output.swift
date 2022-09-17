//
//  Output.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import SwiftUI

@propertyWrapper
public struct Output<Value> {
    private var value: Value
    public init (wrappedValue: Value) {
        value = wrappedValue
    }
    public var wrappedValue: Value {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }
    public static subscript<EnclosingSelf: ObservableObject>(
        _enclosingInstance object: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
    ) -> Value {
        get {
            return object[keyPath: storageKeyPath].value
        }
        set {
            object[keyPath: storageKeyPath].value = newValue
            let selfName = NSExpression(forKeyPath: wrappedKeyPath).keyPath
            guard let outputConnection = (object as? NodeModelBase)?.outputConnection[selfName] else {
                return
            }
            EasyNodeManager.shared.nodeModels[outputConnection.nodeID]!.setValue(newValue, forKey: outputConnection.inputName)
        }
    }
}
