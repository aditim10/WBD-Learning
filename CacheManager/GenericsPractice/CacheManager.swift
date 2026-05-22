struct CacheManager<Key: Hashable, Value> {

    // Storage
    private var storage: [Key: Value] = [:]

    // Save Item
    @discardableResult
    mutating func save(value: Value, for key: Key) -> Value {
        storage[key] = value
        return value
    }

    // Get Item
    func value(for key: Key) throws -> Value {
        guard let value = storage[key] else {
            throw CacheError.itemNotFound
        }
        return value
    }

    // Contains Key
    func contains(key: Key) -> Bool {
        return storage[key] != nil
    }

    // Remove Item
    mutating func removeValue(for key: Key) {
        storage.removeValue(forKey: key)
    }

    // Clear Cache
    mutating func clearCache() {
        storage.removeAll()
    }

    // All Items
    var allItems: [Key: Value] {
        return storage
    }

    // Total Items
    var totalItems: Int {
        return storage.count
    }
}
