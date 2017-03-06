import Dispatch

/// A timer that can be repeatedly scheduled, cancelled, and rescheduled.
class ReusableTimer {
  private var timer: DispatchSourceTimer?
  private let handler: @convention(block) () -> Void

  init(handler: @escaping @convention(block) () -> Void) {
    self.handler = handler
  }

  func scheduleIfNeeded(after interval: DispatchTimeInterval) {
    timer ??= DispatchQueue.main.asyncAfter(interval) { [weak self] in
      self?.handler()
      self?.timer = nil
    }
  }

  func unschedule() {
    timer?.cancel()
    timer = nil
  }

  deinit {
    unschedule()
  }
}
