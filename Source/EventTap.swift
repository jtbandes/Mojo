import Foundation

enum EventTapError: Error {
  case eventTapCreationFailed
  case runLoopSourceCreationFailed
}

class EventTap {

  typealias Callback = (_ event: CGEvent, _ proxy: CGEventTapProxy) -> Void

  private var machPort: CFMachPort?
  private var runLoopSource: CFRunLoopSource?
  private var callback: Callback

  init(for events: CGEventSet, callback cb: @escaping Callback) throws {
    machPort = nil
    runLoopSource = nil
    callback = cb

    let eventTapCallback: CGEventTapCallBack = { (proxy, type, event, userInfo) in
      let obj = Unmanaged<EventTap>.fromOpaque(userInfo!).takeUnretainedValue()
      obj.callback(event, proxy)
      return Unmanaged.passRetained(event)
    }

    guard let port = CGEvent.tapCreate(
      tap: .cgSessionEventTap,
      place: .tailAppendEventTap,
      options: .listenOnly,
      eventsOfInterest: events.rawValue,
      callback: eventTapCallback,
      userInfo: Unmanaged.passUnretained(self).toOpaque()) else {
        throw EventTapError.eventTapCreationFailed
    }
    machPort = port

    guard let source = CFMachPortCreateRunLoopSource(nil, port, 0) else {
      throw EventTapError.runLoopSourceCreationFailed
    }
    runLoopSource = source

    CFRunLoopAddSource(CFRunLoopGetMain(), source, .commonModes)
  }

  var isEnabled: Bool {
    set {
      machPort.map { CGEvent.tapEnable(tap: $0, enable: newValue) }
    }
    get {
      return machPort.map(CGEvent.tapIsEnabled) ?? false
    }
  }

  deinit {
    isEnabled = false
    runLoopSource.map { CFRunLoopRemoveSource(CFRunLoopGetMain(), $0, .commonModes) }
  }

}

