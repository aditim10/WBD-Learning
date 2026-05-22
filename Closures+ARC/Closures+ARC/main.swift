// Single entry point — calls demo functions from each task file

import Foundation

// MARK: 1 — Retain Cycle Fix

print("  1.  Retain Cycle Fix        ")

demonstrateLeak()
demonstrateFixed()

// MARK: 2 — Async Callbacks

print("  2.  Async Callbacks         ")

let vc = ViewController()
vc.loadUserData()
vc.loadWithErrorHandling()

let pipeline = DataPipeline()
pipeline.fetchSecureData { result in
    print("Pipeline final result: \(result)")
}

// MARK: 3 — EventBus

print("  3.  Publisher-Subscriber    ")

let bus = EventBus()

var user1: Subscriber? = Subscriber(name: "Aditi")
var user2: Subscriber? = Subscriber(name: "Riya")
var user3: Subscriber? = Subscriber(name: "Karan")

user1?.listen(to: bus)
user2?.listen(to: bus)
user3?.listen(to: bus)

bus.publish("App launched")

print("\n--- Riya unsubscribes ---")
user2?.unsubscribe(from: bus)
bus.publish("Feature flag updated")

print("\n--- Aditi deallocated ---")
user1 = nil
bus.publish("New user registered")

user3 = nil

// Typed EventBus
print("\n--- Typed EventBus ---")
let typedBus = TypedEventBus<UserEvent>()

typedBus.subscribe { event in
    print("Dashboard: \(event.type) for \(event.username)")
}
typedBus.subscribe { event in
    print("Logger: \(event.type) for \(event.username)")
}

typedBus.publish(UserEvent(type: "LOGIN",  username: "aditi@nitw.ac.in"))
typedBus.publish(UserEvent(type: "LOGOUT", username: "aditi@nitw.ac.in"))

// MARK: 4 — Custom Higher-Order Functions

print("║  4.  map / filter / sort     ║")

let nums = [1, 2, 3, 4, 5, 6]

print("customMap (square):")
print(nums.customMap { $0 * $0 })

print("\ncustomFilter (even):")
print(nums.customFilter { $0 % 2 == 0 })

print("\ncustomSorted (descending):")
print([4, 1, 9, 2, 7].customSorted(by: >))

print("\ncustomReduce (sum):")
print(nums.customReduce(0, +))

print("\nChained — filter evens → square → sort desc:")
let chained = nums
    .customFilter { $0 % 2 == 0 }
    .customMap    { $0 * $0 }
    .customSorted(by: >)
print(chained)

// Keep process alive for async tasks (Task 2)
RunLoop.main.run(until: Date(timeIntervalSinceNow: 5))
