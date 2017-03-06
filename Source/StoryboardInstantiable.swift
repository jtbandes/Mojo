import AppKit

protocol MainStoryboardInstantiable {
  static var storyboardIdentifier: String { get }
}


extension MainStoryboardInstantiable where Self: NSViewController {
  static var storyboardIdentifier: String {
    return NSStringFromClass(Self.self).components(separatedBy: ".").last!
  }

  static func fromStoryboard() -> Self {
    return NSStoryboard.main.instantiateController(withIdentifier: self.storyboardIdentifier) as! Self
  }
}
