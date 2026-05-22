// Publisher-Subscriber pattern implemented using closures
// No top-level executable code here — run from main.swift

import Foundation

// MARK: EventBus

class EventBus {

    typealias EventHandler = (String) -> Void
    typealias SubscriberToken = UUID

    private var subscribers: [SubscriberToken: EventHandler] = [:]

    @discardableResult
    func subscribe(_ handler: @escaping EventHandler) -> SubscriberToken {
        let token = UUID()
        subscribers[token] = handler
        return token
    }

    func unsubscribe(token: SubscriberToken) {
        subscribers.removeValue(forKey: token)
        print("Subscriber \(token.uuidString.prefix(8)) unsubscribed")
    }

    func publish(_ event: String) {
        print("\nPublishing event: \"\(event)\"")
        print("Active subscribers: \(subscribers.count)")
        for handler in subscribers.values {
            handler(event)
        }
    }

    var subscriberCount: Int { subscribers.count }
}

// MARK: Subscriber

class Subscriber {

    let name: String
    private var token: EventBus.SubscriberToken?

    init(name: String) {
        self.name = name
        print("\(name) created")
    }

    func listen(to bus: EventBus) {
        token = bus.subscribe { [weak self] event in
            guard let self = self else {
                print("(stale subscriber received event but self is gone)")
                return
            }
            print("  \(self.name) received: \(event)")
        }
        print("\(name) subscribed with token \(token!.uuidString.prefix(8))")
    }

    func unsubscribe(from bus: EventBus) {
        guard let token = token else { return }
        bus.unsubscribe(token: token)
        self.token = nil
    }

    deinit {
        print("\(name) deinitialized")
    }
}

// MARK: Typed EventBus (generic version)

class TypedEventBus<T> {

    typealias Handler = (T) -> Void
    private var handlers: [Handler] = []

    func subscribe(_ handler: @escaping Handler) {
        handlers.append(handler)
    }

    func publish(_ event: T) {
        handlers.forEach { $0(event) }
    }
}

struct UserEvent {
    let type: String
    let username: String
}
