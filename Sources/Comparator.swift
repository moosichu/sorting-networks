///
/// This protocol is used to create generic comparators in a comparison network
///
protocol Comparator {
    associatedtype T
    static func compare(_ a: T, _ b: T) -> Bool
}