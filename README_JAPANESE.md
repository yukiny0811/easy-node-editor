## EasyNodeEditor

**ノードエディタとしての複雑なロジック部分を開発者ができるだけ意識せずに済むようにして、ノードの作成やその他の開発に集中できるようなライブラリ**    
というコンセプトで作成しています

## デモ
こんな感じのノードエディタです。    
![GIF 2022-09-17 at 8.27.39 PM.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/567236/667b921e-2a50-2974-c46f-34e736963a93.gif)

シェーダーエディタっぽいものも簡単に作れます。
![GIF 2022-09-19 at 6.18.32 AM.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/567236/75332f6e-230e-f892-0ec3-dc3fd3a4f3eb.gif)



## 使い方1 - 標準的な出力ノード

### Step 1. ノードを作成

好きな名前でクラスを作成して、```NodeModelBase```クラスを継承してください。

```.swift
class YourOutputNode: NodeModelBase {
}
```

### Step 2. 出力を作成

好きな名前で変数を作って、```@objc```と```@Output```をつけてください。
変数はいくらでも作ってOKで、作った分だけノードに出力が作成されます。
ちなみにノードに表示される出力名はこの変数名になるので、命名の際はそれだけ気をつけてください。

```.swift
class YourOutputNode: NodeModelBase {
    @objc @Output var output: Int = 3
}
```

### Step 3. ノードを登録

EasyNodeEditorを使うときに引数としてクラスの型を渡してあげてください。

```.swift
struct ContentView: View {
    var body: some View {
        EasyNodeEditor(nodeTypes: [YourOutputNode.self])
    }
}
```

これだけ！
下の画像のようなノードが自動的に登録されます。
本当に簡単に出力ノードが作れたと思います。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/567236/e56777a0-e7fe-c8f4-f0e9-3b85b9c087a7.png)


## 使い方2 - 標準的な入出力ノード

### Step 1. ノードを作る

```.swift
class YourIONode: NodeModelBase {
}
```

### Step 2. 入力と出力を作る

出力の際には```@objc```と```@Output```をつけましたが、入力を作る際には```@objc```と```@Input```をつけます。
今回は```input```と```output```という名前の変数を作りましたが、本当にここの名前はなんでもいいです。

```.swift
class YourIONode: NodeModelBase {
    @objc @Input var input: Int = 0
    @objc @Output var output: Int = 0
}
```

### Step 3. 入力の値が変わった時の処理を記述

```processOnChange()```関数をoverrideして、中に好きな処理を書きましょう。
今回は入力値を5倍にするノードを作ってみます。
ちなみに```processOnChange()```の中でinputの値を変えると無限ループが始まるので気をつけてください。

```.swift
class YourIONode: NodeModelBase {
    @objc @Input var input: Int = 0
    @objc @Output var output: Int = 0
    override func processOnChange() {
        output = input * 5
    }
}
```

### Step 4. ノードを登録

出力ノードの時と同じように登録しましょう。

```.swift
struct ContentView: View {
    var body: some View {
        EasyNodeEditor(nodeTypes: [YourOutputNode.self, YoutIONode.self])
    }
}
```

これも簡単ですね！
こんな感じのノードが登録されます。    
![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/567236/0fd8406d-0a33-de2c-5cc4-588b410c9e05.png)

## 使い方3 - 標準的な表示ノード

### Step 1. ノードを作成

```.swift
class YourDisplayNode: NodeModelBase {
}
```

### Step 2. 入力を作成

```.swift
class YourDisplayNode: NodeModelBase {
    @objc @Input var input: Int = 0
}
```

### Step3. 値を表示するためのViewを作る

```middleContent()```関数をoverrideして、好きにViewを定義しましょう。
SwiftUIの一般的な文法で書けるのでまじで簡単に書けるはずです。
実装の都合上```AnyView```で囲ってあげるのだけお願いします。

```.swift
class YourDisplayNode: NodeModelBase {
    @objc @Input var input: Int = 0
    override func middleContent() -> AnyView {
        return AnyView(
             Text("number is now -> \(input)")
        )
    }
}
```

### Step 4. ノードを登録

```.swift
struct ContentView: View {
    var body: some View {
        EasyNodeEditor(nodeTypes: [YourOutputNode.self, YoutIONode.self, YourDisplayNode.self])
    }
}
```

簡単ですね。こんな感じのノードが登録されます。    
![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/567236/8396efb8-1542-0b17-3f4a-ebb73895e698.png)

## 使い方4 - 標準的なインタラクティブノード

使い方1~3は読んだものとして進めますね。
インタラクションが必要なノード用には```@Middle```を用意しています。
```@Input```と```@Middle```がついた変数の値が更新されるたびに、```processOnChange()```メソッドが呼ばれるようになっています。
この例であるような```Slider```などバインディングが必要なUIパーツを使いたい場合は、```@ObservableObject```を継承した新しいクラスを作成して、```@Published```をつけた変数をその中で定義してください。
実装の都合上申し訳ないのですが```NodeModelBase```クラスを継承したクラスの中ではUIパーツ用のバインディングができない仕様になっています。
ノードができたら今までと同じように登録しましょう。

```.swift
class YourInteractiveNodeSubModel: ObservableObject {
    @Published var sliderValue: Double = 0.0
}
class YourInteractiveNode: NodeModelBase {
    @objc @Input var input: Int = 0
    @objc @Middle var count: Int = 0
    @objc @Output var output: Int = 0
    override func processOnChange() {
        output = input * count
    }
    override func middleContent() -> AnyView {
        return AnyView(
            Group {
                Slider(value: binding(\YourInteractiveNode.count), in: 0...100)
            }
            .frame(minWidth: 200, maxWidth: 200)
            .fixedSize()
        )
    }
}
```

自分でもびっくりするくらい簡単です。こんなノードが登録されます。    
![GIF 2022-09-17 at 8.21.30 PM.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/567236/1c3aca8b-5d8d-f690-ec55-3ce7c61a2956.gif)

## 全体コード

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
            Text("number is now -> \(input)")
        )
    }
}

class YourInteractiveNode: NodeModelBase {
    @objc @Input var input: Int = 0
    @objc @Middle var count: Int = 0
    @objc @Output var output: Int = 0
    override func processOnChange() {
        output = input * count
    }
    override func middleContent() -> AnyView {
        return AnyView(
            Group {
                Slider(value: binding(\YourInteractiveNode.count), in: 0...100)
            }
            .frame(minWidth: 200, maxWidth: 200)
            .fixedSize()
        )
    }
}
```
