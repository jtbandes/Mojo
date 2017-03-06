import CoreGraphics

extension CGEventType {
  var maskBit: CGEventSet {
    return CGEventSet(rawValue: 1 << UInt64(self.rawValue))
  }
}

// <https://bugs.swift.org/browse/SR-4073>
struct CGEventSet: OptionSet {
  let rawValue: CGEventMask

  static let leftMouseDown = CGEventType.leftMouseDown.maskBit
  static let leftMouseUp = CGEventType.leftMouseUp.maskBit
  static let rightMouseDown = CGEventType.rightMouseDown.maskBit
  static let rightMouseUp = CGEventType.rightMouseUp.maskBit
  static let mouseMoved = CGEventType.mouseMoved.maskBit
  static let leftMouseDragged = CGEventType.leftMouseDragged.maskBit
  static let rightMouseDragged = CGEventType.rightMouseDragged.maskBit
  static let keyDown = CGEventType.keyDown.maskBit
  static let keyUp = CGEventType.keyUp.maskBit
  static let flagsChanged = CGEventType.flagsChanged.maskBit
  static let scrollWheel = CGEventType.scrollWheel.maskBit
  static let tabletPointer = CGEventType.tabletPointer.maskBit
  static let tabletProximity = CGEventType.tabletProximity.maskBit
  static let otherMouseDown = CGEventType.otherMouseDown.maskBit
  static let otherMouseUp = CGEventType.otherMouseUp.maskBit
  static let otherMouseDragged = CGEventType.otherMouseDragged.maskBit
  static let tapDisabledByTimeout = CGEventType.tapDisabledByTimeout.maskBit
  static let tapDisabledByUserInput = CGEventType.tapDisabledByUserInput.maskBit

  static let allEvents = CGEventSet(rawValue: ~CGEventMask.allZeros)
}


extension CGEvent {
  var keyboardString: String {
    var length = 0
    keyboardGetUnicodeString(maxStringLength: 0,
                             actualStringLength: &length,
                             unicodeString: nil)

    var chars = [UniChar](repeating: 0, count: length)
    keyboardGetUnicodeString(maxStringLength: chars.count,
                             actualStringLength: &length,
                             unicodeString: &chars)

    return String(utf16CodeUnits: chars, count: length)
  }
}


extension CGWindowLevelKey {
  var level: Int {
    return Int(CGWindowLevelForKey(self))
  }
}
