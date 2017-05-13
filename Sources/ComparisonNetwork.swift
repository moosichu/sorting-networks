/// Represents a wire in a comparison network
private struct Wire<T> {
    var connections : Array<Int>
    init() {
        connections = [Int]()
    }
}

class ComparisonNetwork<C : Comparator> {
    let size : Int
    private var connections = [(w1: Int, w2: Int)]()

    init(size: Int) {
        self.size = size
    }

    ///
    /// Create a connection between two wires.
    ///
    /// The connection will always be evaluated after previous ones if
    /// conflicting. 
    ///
    func createConnection(between wire1: Int, and wire2: Int) {
        var w1 = wire1
        var w2 = wire2
        assert(w1 >= 0 && w1 < size, "first parameter incorrectly configured")
        assert(w2 >= 0 && w2 < size, "first parameter incorrectly configured")
        // Ensure the connections is always done in the correct "order"
        if(w1 > w2) {
            swap(&w1, &w2)
        }
        connections.append((w1: w1, w2: w2))
    }

    ///
    /// Print the network from top-to-bottom in the terminal, with "x"s marking
    /// connected nodes.
    ///
    func printNetwork() {
        for connection in connections {
            var charArr: [Character] = Array(repeating: "o", count: size)
            charArr[connection.w1] = "x"
            charArr[connection.w2] = "x"
            print(String(charArr))
        }
    }

    ///
    /// Run the comparison network with the given input values
    ///
    func runNetwork(values wireValues: inout Array<C.T>) {
        assert(wireValues.count == size, "number of inputs needs to match number of wires")
        // For each connection, determine if the values will be swapped
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