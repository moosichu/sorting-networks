struct IntComparator: Comparator {
    typealias T = Int
    static func compare(_ a: Int, _ b: Int) -> Bool {
        return a > b
    }
}

/// Represents a wire in a comparison network
struct Wire<T> {
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

struct BatcherBitonicSorter<C: Comparator> {
    let network: ComparisonNetwork<C>

    private func createHalfCleaner(at cleanerPosition: Int, size: Int) {
        let halfsize = size / 2

        for index in 0..<halfsize {
            network.createConnection(between: index + cleanerPosition,
                                     and: index + halfsize + cleanerPosition)
        }
    }

    private func createBitonicSorter(at sorterPosition: Int, logsize: Int) {
        var cleanerSize = 1 << logsize
        var numCleaners = 1
        for _ in 0..<logsize {
            for cleaner in 0..<numCleaners {
                let cleanerPosition = sorterPosition + (cleaner * cleanerSize);
                createHalfCleaner(at: cleanerPosition,
                                  size: cleanerSize)
            }
            cleanerSize = cleanerSize / 2
            numCleaners = numCleaners * 2
        }
    }

    private func createMerger(at mergerPosition: Int, size: Int) {
        for index in 0..<(size/2) {
            network.createConnection(between: index + mergerPosition,
                                     and: (size + mergerPosition - 1) - index)
        }
    }

    private func createMergerSorter(at sorterPosition: Int, logsize: Int) {
        if(logsize == 1) {
            network.createConnection(between: sorterPosition, and: sorterPosition + 1)
        } else {
            createMerger(at: sorterPosition, size: 1 << logsize)
            createBitonicSorter(at: sorterPosition, logsize: logsize)
        }
    }

    init(logsize: Int) {
        network = ComparisonNetwork<C>(size: 1 << logsize)
        var numSorters = 1 << logsize
        for sublogsize in 1...logsize {
            numSorters = numSorters / 2
            print("creating \(numSorters) mergerSorter of size \(1 << sublogsize)")
            for sorter in 0..<numSorters {
                let sorterPosition = sorter * (1 << sublogsize)
                print("creating mergerSorter at \(sorterPosition)")
                createMergerSorter(at: sorterPosition, logsize: sublogsize)
            }
        }
    }
}

let miniNetwork = ComparisonNetwork<IntComparator>(size: 2)
miniNetwork.createConnection(between: 0, and: 1)

var values = [3, 1]
print("pre-sort: \(values)")
miniNetwork.runNetwork(values: &values)
print("postsort: \(values)")

let bitonicSorterH = ComparisonNetwork<IntComparator>(size: 8)
bitonicSorterH.createConnection(between: 0, and: 4)
bitonicSorterH.createConnection(between: 1, and: 5)
bitonicSorterH.createConnection(between: 2, and: 6)
bitonicSorterH.createConnection(between: 3, and: 7)

bitonicSorterH.createConnection(between: 0, and: 2)
bitonicSorterH.createConnection(between: 1, and: 3)
bitonicSorterH.createConnection(between: 4, and: 6)
bitonicSorterH.createConnection(between: 5, and: 7)

bitonicSorterH.createConnection(between: 0, and: 1)
bitonicSorterH.createConnection(between: 2, and: 3)
bitonicSorterH.createConnection(between: 4, and: 5)
bitonicSorterH.createConnection(between: 6, and: 7)

var values2 = [1, 2, 3, 4, 2, 0, -2, 0]
print("pre-sort: \(values2)")
bitonicSorterH.runNetwork(values: &values2)
print("postsort: \(values2)")

let bitonicSorter = BatcherBitonicSorter<IntComparator>(logsize: 3).network
bitonicSorter.printNetwork()
var values3 = [10, 30, 11, 20, 4, 330, 21, 110]
print("pre-sort: \(values3)")
bitonicSorter.runNetwork(values: &values3)
print("postsort: \(values3)")
