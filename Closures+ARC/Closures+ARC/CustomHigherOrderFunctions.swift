// Custom implementations of map, filter, sort, reduce, compactMap using closures + generics
// Only declarations here — all demo calls are in main.swift

// MARK: Custom map

extension Array {

    func customMap<T>(_ transform: (Element) -> T) -> [T] {
        var result: [T] = []
        for item in self {
            result.append(transform(item))
        }
        return result
    }
}

// MARK: Custom filter

extension Array {

    func customFilter(_ condition: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for item in self {
            if condition(item) {
                result.append(item)
            }
        }
        return result
    }
}

// MARK: Custom sort (bubble sort)

extension Array {

    func customSorted(by comparison: (Element, Element) -> Bool) -> [Element] {
        var arr = self
        let n = arr.count
        for i in 0..<n {
            for j in 0..<(n - i - 1) {
                if !comparison(arr[j], arr[j + 1]) {
                    arr.swapAt(j, j + 1)
                }
            }
        }
        return arr
    }
}

// MARK: Custom reduce

extension Array {

    func customReduce<T>(_ initialValue: T, _ combine: (T, Element) -> T) -> T {
        var accumulator = initialValue
        for item in self {
            accumulator = combine(accumulator, item)
        }
        return accumulator
    }
}

// MARK: Custom compactMap

extension Array {

    func customCompactMap<T>(_ transform: (Element) -> T?) -> [T] {
        var result: [T] = []
        for item in self {
            if let transformed = transform(item) {
                result.append(transformed)
            }
        }
        return result
    }
}
