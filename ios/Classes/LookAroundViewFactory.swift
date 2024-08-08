import Flutter
import UIKit

class LookAroundViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        if #available(iOS 16.0, *) {
            return LookAroundView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger)
        } else {
            return MapView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger)
        }
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
