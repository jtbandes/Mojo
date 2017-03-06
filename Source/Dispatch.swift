import Dispatch

extension Int {
  var seconds: DispatchTimeInterval { return .seconds(self) }
  var milliseconds: DispatchTimeInterval { return .milliseconds(self) }
  var microseconds: DispatchTimeInterval { return .microseconds(self) }
  var nanoseconds: DispatchTimeInterval { return .nanoseconds(self) }
}


extension DispatchQueue {
  func asyncAfter(_ interval: DispatchTimeInterval,
                  leeway: DispatchTimeInterval = 0.nanoseconds,
                  handler: @escaping @convention(block) () -> Void) -> DispatchSourceTimer {
    let timer = DispatchSource.makeTimerSource(flags: [], queue: self)
    timer.setEventHandler(handler: handler)
    timer.scheduleOneshot(deadline: .now() + interval, leeway: leeway)
    timer.resume()
    return timer
  }
}
