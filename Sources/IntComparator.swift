struct IntComparator: Comparator {
    typealias T = Int
    static func compare(_ a: Int, _ b: Int) -> Bool {
        return a > b
    }
}