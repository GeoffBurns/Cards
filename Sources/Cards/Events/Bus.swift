//
//  Bus.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 7/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//
public final class AsyncBehaviorRelay<Element> {
    private var continuations: [UUID: AsyncStream<Element>.Continuation] = [:]
    private let lock = NSLock()
    private var _value: Element

    public init(value: Element) {
        self._value = value
    }

    /// Current value (thread-safe getter)
    public var value: Element {
        lock.lock()
        defer { lock.unlock() }
        return _value
    }

    /// Subscribe to stream of values (like `asObservable()` in Rx)
    public func asStream() -> AsyncStream<Element> {
        AsyncStream { continuation in
            let id = UUID()

            lock.lock()
            continuations[id] = continuation
            let current = _value
            lock.unlock()

            // Immediately emit current value
            continuation.yield(current)

            continuation.onTermination = { @Sendable _ in
                self.lock.lock()
                self.continuations.removeValue(forKey: id)
                self.lock.unlock()
            }
        }
    }

    /// Accept new value (like `.accept()` in Rx)
    public func accept(_ newValue: Element) {
        lock.lock()
        _value = newValue
        continuations.values.forEach { $0.yield(newValue) }
        lock.unlock()
    }
}


public final class AsyncRelay<Element> {
    private var continuations: [ObjectIdentifier: AsyncStream<Element>.Continuation] = [:]
    private let lock = NSLock()

    public init() {}

    public func asStream() -> AsyncStream<Element> {
        AsyncStream { continuation in
            let id = ObjectIdentifier(continuation as AnyObject)

            lock.lock()
            continuations[id] = continuation
            lock.unlock()

            continuation.onTermination = { @Sendable _ in
                self.lock.lock()
                self.continuations.removeValue(forKey: id)
                self.lock.unlock()
            }
        }
    }

    public func accept(_ value: Element) {
        lock.lock()
        continuations.values.forEach { $0.yield(value) }
        lock.unlock()
    }
}



public class Bus {
    
    public let events = AsyncRelay<GameEvent>()
    
    public let notices = AsyncRelay<GameNotice>()
    
    public static let sharedInstance = Bus()
    fileprivate init() { }
    
    public static func send(_ gameEvent:GameEvent)
    {
        sharedInstance.events.accept(gameEvent)
    }
    
    public static func send(_ gameNotice:GameNotice)
    {
        sharedInstance.notices.accept(gameNotice)
    }
    
    public func send(_ gameEvent:GameEvent)
    {
        self.events.accept(gameEvent)
    }
    public func send(_ gameNotice:GameNotice)
    {
        self.notices.accept(gameNotice)
    }
}
