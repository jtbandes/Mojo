import AppKit

/// A popover floating on top of other content on the screen.
/// It can be shown at an arbitrary position in global display space.
class GlobalPopover {

  private let popover = NSPopover()
  private var observers: [NSObjectProtocol] = []

  private let hostWindow = HostWindow()

  init(content: NSViewController) {
    popover.behavior = .transient
    popover.contentViewController = content

    observers << popover.addObserver(for: .NSPopoverWillClose) { _ in
      // TODO: factor this out
      NSApp.deactivate()
    }
  }

  func show(from point: CGPoint, preferredEdge: NSRectEdge = .minY) -> Bool {
    return show(
      from: CGRect(origin: point, size: CGSize(width: 1, height: 1)),
      preferredEdge: preferredEdge)
  }

  func show(from rect: CGRect, preferredEdge: NSRectEdge = .minY) -> Bool {
    guard let hostView = hostWindow.contentView else {
      return false
    }

    hostWindow.setFrame(rect, display: false)
    hostWindow.orderFrontRegardless()

    popover.show(relativeTo: hostView.bounds, of: hostView, preferredEdge: preferredEdge)

    if let win = popover.contentViewController?.view.window as? NSPanel {
      // Allow the window to become key even if the app is not active.
      win.styleMask.insert(.nonactivatingPanel)
      win.makeKey()
      if win.isKeyWindow {
        return true
      }
    }

    close(animated: false)
    return false
  }

  func close(animated shouldAnimate: Bool = false) {
    popover.animates = shouldAnimate
    popover.close()
  }

  deinit {
    observers.forEach { NotificationCenter.default.removeObserver($0) }
  }
}


private class HostWindow: NSPanel {

  override var canBecomeKey: Bool { return true }

  init() {
    super.init(
      contentRect: .zero,
      styleMask: [.borderless, .nonactivatingPanel],
      backing: .buffered,
      defer: false)

    level = CGWindowLevelKey.mainMenuWindow.level
    hasShadow = false
    isOpaque = false
    backgroundColor = .clear
  }

}
