import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var eventMonitor: Any?

  lazy var showTimer: ReusableTimer = ReusableTimer() { [weak self] in self?.show() }

  let popover = GlobalPopover(content: PickerViewController.fromStoryboard())

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    startEventMonitor()
  }

  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    startEventMonitor()
    return false
  }

  func startEventMonitor() {
    if AXProcess.isTrusted(prompt: true) {
      eventMonitor ??= NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
        self?.handleEvent(event)
      }
    }
  }

  func handleEvent(_ event: NSEvent) {
    if event.characters == ":" {
      showTimer.scheduleIfNeeded(after: 300.milliseconds)
    }
    else {
      showTimer.unschedule()
    }
  }

  deinit {
    eventMonitor.map(NSEvent.removeMonitor)
  }

  func show() {
    guard let el = AXUIElement.systemWide.focusedUIElement, let bounds = el.cursorBounds else {
      return
    }

    _ = popover.show(from: bounds.rightEdge)

    // TODO: blacklist apps?
    // TODO: watch for original element disappearing?
    // TODO: forward some events through to the original app?
    //   Or use CGEventTap to steal some events without making the window key?
    //   Advantage: less disruptive to interactions with the original app
    //   Disadvantage: no default in-window event handling, have to guess when to steal events
    //   Unknown: easier or harder to modify text in the field?
  }

}

