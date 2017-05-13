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
            for sorter in 0..<numSorters {
                let sorterPosition = sorter * (1 << sublogsize)
                createMergerSorter(at: sorterPosition, logsize: sublogsize)
            }
        }
    }
}