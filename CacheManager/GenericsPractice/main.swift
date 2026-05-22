import Foundation

let path = "/Users/admishra/Documents/WBD-Learning/CacheManager/GenericsPractice/console.txt"

freopen(path, "w", stdout)

var userCache = CacheManager<Int, String>()

// Save Data
userCache.save(value: "Aditi", for: 1)
userCache.save(value: "Ayan", for: 2)
userCache.save(value: "Sharad", for: 3)

// Show Cache
print("Cache:", userCache.allItems)
print()

// Fetch Existing Value
do {
    let value = try userCache.value(for: 1)
    print("Fetched value:", value)
} catch CacheError.itemNotFound {
    print("Error: Item not found")
} catch {
    print("Unexpected error:", error)
}
print()

// Contains Check
print("Contains key 2:", userCache.contains(key: 2))
print("Contains key 99:", userCache.contains(key: 99))
print()

// Remove Item
userCache.removeValue(for: 2)
print("After removing key 2:", userCache.allItems)
print()

// Total Items
print("Total items:", userCache.totalItems)
print()

// Error Handling (missing key)
do {
    let value = try userCache.value(for: 100)
    print("Fetched value:", value)
} catch CacheError.itemNotFound {
    print("Error: Item not found")
} catch {
    print("Unexpected error:", error)
}
print()

// Clear Cache
userCache.clearCache()
print("After clear:", userCache.allItems)
print("Total items:", userCache.totalItems)

// try? try! / throws async / await try 
