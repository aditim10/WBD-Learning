// Demonstrates strong reference cycles and the weak fix
// No top-level executable code here — run from main.swift

// MARK: Wrong version (memory leak)

class PersonBad {
    let name: String
    var apartment: ApartmentBad?

    init(name: String) {
        self.name = name
        print("[Bad] \(name) initialized")
    }
    deinit { print("[Bad] \(name) deinitialized") }
}

class ApartmentBad {
    let unit: String
    var tenant: PersonBad?          // strong reference cycle

    init(unit: String) {
        self.unit = unit
        print("[Bad] Apartment \(unit) initialized")
    }
    deinit { print("[Bad] Apartment \(unit) deinitialized") }
}

// MARK: Fixed version using weak

class Person {
    let name: String
    var apartment: Apartment?

    init(name: String) {
        self.name = name
        print("[Fixed] \(name) initialized")
    }
    deinit { print("[Fixed] \(name) deinitialized") }
}

class Apartment {
    let unit: String
    weak var tenant: Person?        // weak — breaks the cycle

    init(unit: String) {
        self.unit = unit
        print("[Fixed] Apartment \(unit) initialized")
    }
    deinit { print("[Fixed] Apartment \(unit) deinitialized") }
}

// MARK: Demo functions (called from main.swift)

func demonstrateLeak() {
    print("\n--- Retain Cycle (memory leak) ---")
    var person: PersonBad? = PersonBad(name: "Aditi")
    var apartment: ApartmentBad? = ApartmentBad(unit: "A-101")
    person?.apartment = apartment
    apartment?.tenant = person
    person = nil
    apartment = nil
    print("Notice: deinit was NOT called above — memory leaked!\n")
}

func demonstrateFixed() {
    print("--- Fixed with weak (no memory leak) ---")
    var person: Person? = Person(name: "Aditi")
    var apartment: Apartment? = Apartment(unit: "A-101")
    person?.apartment = apartment
    apartment?.tenant = person
    person = nil
    apartment = nil
    print("Both objects properly deallocated!\n")
}
