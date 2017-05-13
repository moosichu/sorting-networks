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
