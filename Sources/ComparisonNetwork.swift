/// Represents a wire in a comparison network
private struct Wire<T> {
    var connections : Array<Int>
    init() {
        connections = [Int]()
    }
}

class ComparisonNetwork<C : Comparator> {
    let size : Int
    private var wires : Array<Wire<C.T>>
    private var connections = [(w1: Int, w2: Int)]()
    init(size: Int) {
        self.size = size
        wires = Array(repeating: Wire<C.T>(), count: size)
    }

    func createConnection(between wire1: Int, and wire2: Int) {
        var w1 = wire1
        var w2 = wire2
        assert(w1 >= 0 && w1 < size, "first parameter incorrectly configured")
        assert(w2 >= 0 && w2 < size, "first parameter incorrectly configured")
        if(w1 > w2) {
            swap(&w1, &w2)
        }
        wires[w1].connections.append(w2)
        wires[w2].connections.append(w1)
        connections.append((w1: w1, w2: w2))
    }

    func printNetwork() {
        for connection in connections {
            var charArr: [Character] = Array(repeating: "o", count: size)
            charArr[connection.w1] = "x"
            charArr[connection.w2] = "x"
            print(String(charArr))
        }
    }

    func runNetwork(values wireValues: inout Array<C.T>) {
        assert(wireValues.count == size, "number of inputs needs to match number of wires")
        // var wireStates = Array(repeating: 0, count: wires.count)
        for connection in connections {
            let shouldSwap = C.compare(wireValues[connection.w1], wireValues[connection.w2])
            if(shouldSwap) {
                let temp = wireValues[connection.w1]
                wireValues[connection.w1] = wireValues[connection.w2]
                wireValues[connection.w2] = temp
            }
        }
    }
}