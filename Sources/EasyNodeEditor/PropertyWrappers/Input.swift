//
//  Input.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import SwiftUI
import Combine

@propertyWrapper
public class Input<Value> {
    @Published private var value: Value
    public init(wrappedValue: Value) {
        _value = Published(wrappedValue: wrappedValue)
    }
    public var wrappedValue: Value {
        get {
            value
        }
        set {
            value = newValue
        }
    }
    public static subscript<EnclosingSelf: ObservableObject>(
        _enclosingInstance object: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Input>
    ) -> Value {
        get {
            return object[keyPath: storageKeyPath].value
        }
        set {
            object[keyPath: storageKeyPath].value = newValue
            (object as? NodeModelBase)?.processOnChange()
            (object.objectWillChange as? ObservableObjectPublisher)?.send()
        }
    }
}
