import Foundation

internal class Defaults {

  static var isFirstLaunch: Bool {
    get { return self.lastLaunchDate == nil }
  }

  static var lastLaunchDate: Date? {
    get {
      return UserDefaults.standard.object(forKey: "MojoLastLaunch") as? Date
    }
    set {
      if let val = newValue {
        UserDefaults.standard.set(val, forKey: "MojoLastLaunch")
      }
      else {
        UserDefaults.standard.removeObject(forKey: "MojoLastLaunch")
      }
    }
  }

}
