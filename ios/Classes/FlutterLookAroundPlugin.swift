import Flutter
import UIKit
import MapKit

public class SwiftLookaroundPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = LookAroundViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "lookaround_view")
    }
}

@available(iOS 16.0, *)
class LookAroundView: NSObject, FlutterPlatformView {
    private var containerView: UIView
    private var lookAroundView: MKLookAroundViewController?
    private var scene: MKLookAroundScene?
    private var channel: FlutterMethodChannel?
    private var parentViewController: UIViewController?

    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger?) {
        containerView = UIView(frame: frame)
        channel = FlutterMethodChannel(name: "lookaround_view_\(viewId)", binaryMessenger: messenger!)
        super.init()
        channel?.setMethodCallHandler(handleMethodCall)

        if let args = args as? [String: Any] {
            let params = CreationParams(arguments: args)
            setupView(params: params)
        }
    }

    private func setupView(params: CreationParams) {
        guard let latitude = params.latitude, let longitude = params.longitude else {
            notifyLookAroundAvailability(false, "Invalid parameters")
            return
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        

        let lookAroundRequest = MKLookAroundSceneRequest(coordinate: coordinate)
        lookAroundRequest.getSceneWithCompletionHandler { [weak self] (scene, error) in
            self?.handleLookAroundRequestCompletion(scene: scene, error: error, params: params)
        }
    }

    private func handleLookAroundRequestCompletion(scene: MKLookAroundScene?, error: Error?, params: CreationParams) {
        if let error = error as NSError? {
            handleLookAroundRequestError(error)
        } else if let scene = scene {
            setupLookAroundView(scene: scene, params: params)
            notifyLookAroundAvailability(true, nil)
        } else {
            notifyLookAroundAvailability(false, "LookAround scene not found")
        }
    }

    private func handleLookAroundRequestError(_ error: NSError) {
        if error.domain == "GEOErrorDomain" && error.code == -3 {
            let timeUntilReset = error.userInfo["timeUntilReset"] as? Int ?? 0
            let message = "Request throttled. Please wait \(timeUntilReset) seconds before retrying."
            notifyLookAroundAvailability(false, message)
        } else {
            let errorMessage = error.localizedDescription
            notifyLookAroundAvailability(false, errorMessage)
        }
    }

    private func setupLookAroundView(scene: MKLookAroundScene, params: CreationParams) {
        self.scene = scene
        self.lookAroundView = MKLookAroundViewController(scene: scene)
        
        guard let lookAroundVC = self.lookAroundView else { return }
        
        lookAroundVC.view.frame = self.containerView.bounds
        lookAroundVC.view.clipsToBounds = true
        lookAroundVC.isNavigationEnabled = params.isNavigationEnabled
        lookAroundVC.showsRoadLabels = params.showsRoadLabels
        lookAroundVC.badgePosition = params.badgePosition
        lookAroundVC.pointOfInterestFilter = params.POIPointOfInterestFilter
        
        self.containerView.addSubview(lookAroundVC.view)
        self.containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let parentVC = findParentViewController() {
            parentVC.addChild(lookAroundVC)
            lookAroundVC.didMove(toParent: parentVC)
            self.parentViewController = parentVC
        }

        NSLayoutConstraint.activate([
            lookAroundVC.view.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            lookAroundVC.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            lookAroundVC.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            lookAroundVC.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
        ])

        self.containerView.layoutIfNeeded()
    }

    private func notifyLookAroundAvailability(_ isAvailable: Bool, _ message: String? = nil) {
        let data: [String: Any] = ["isAvailable": isAvailable, "message": message ?? ""]
        channel?.invokeMethod("LookAround#availability", arguments: data)
    }

    private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "LookAround#updateOptions":
            if let properties = call.arguments as? [String: Any] {
                updateOptions(properties: properties)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
            }

        case "LookAround#setNavigationEnabled":
            setNavigationEnabled(call.arguments, result)
        case "LookAround#setShowRoadLabels":
            setShowsRoadLabels(call.arguments, result)
        case "LookAround#setBadgePosition":
            setBadgePosition(call.arguments, result) 
        case "LookAround#setPOIPointOfInterestFilter":
            setPOIPointOfInterestFilter(call.arguments, result)
        case "deactivate":
            deactivate()
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func setNavigationEnabled(_ arg: Any?, _ result: FlutterResult? = nil) {
        var isNavigationEnabled: Bool?
        if let arg = arg as? [String: Any] {
            isNavigationEnabled = arg["isNavigationEnabled"] as? Bool
        } else if let arg = arg as? Bool {
            isNavigationEnabled = arg
        }
        if let isNavigationEnabled = isNavigationEnabled {
            lookAroundView?.isNavigationEnabled = isNavigationEnabled
        }
        result?("setNavigationEnabled done")
    }

    private func setShowsRoadLabels(_ arg: Any?, _ result: FlutterResult? = nil) {
        var showsRoadLabels: Bool?
        if let arg = arg as? [String: Any] {
            showsRoadLabels = arg["showsRoadLabels"] as? Bool
        } else if let arg = arg as? Bool {
            showsRoadLabels = arg
        }
        if let showsRoadLabels = showsRoadLabels {
            lookAroundView?.showsRoadLabels = showsRoadLabels
        }
        result?("setShowsRoadLabels done")
    }

    private func setBadgePosition(_ arg: Any?, _ result: FlutterResult? = nil) {
        var badgePosition: MKLookAroundBadgePosition?
        if let arg = arg as? [String: Any] {
            if let badgePositionString = arg["badgePosition"] as? String {
                badgePosition = MKLookAroundBadgePosition.fromString(badgePositionString)
                lookAroundView?.badgePosition = badgePosition!
            }
        } else if let arg = arg as? String {
            badgePosition = MKLookAroundBadgePosition.fromString(arg)
            lookAroundView?.badgePosition = badgePosition!
        }
        result?("setBadgePosition done")
    }

    private func setPOIPointOfInterestFilter(_ arg: Any?, _ result: FlutterResult? = nil) {
        var pointOfInterestFilter: MKPointOfInterestFilter?
        if let arg = arg as? [String: Any] {
            pointOfInterestFilter = MKPointOfInterestFilter.fromMap(arg)
            lookAroundView?.pointOfInterestFilter = pointOfInterestFilter!  
        }
        result?("setPOIPointOfInterestFilter done")
    }

    private func updateOptions(properties: [String: Any]) {
        if let lookAroundView = lookAroundView {
            if let latitude = properties["latitude"] as? Double, let longitude = properties["longitude"] as? Double {
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let lookAroundRequest = MKLookAroundSceneRequest(coordinate: coordinate)
                lookAroundRequest.getSceneWithCompletionHandler { [weak self] (scene, error) in
                    self?.handleLookAroundRequestCompletion(scene: scene, error: error, params: CreationParams(arguments: properties))
                }
            }
            if let isNavigationEnabled = properties["isNavigationEnabled"] as? Bool {
                lookAroundView.isNavigationEnabled = isNavigationEnabled
            }
            if let showsRoadLabels = properties["showsRoadLabels"] as? Bool {
                lookAroundView.showsRoadLabels = showsRoadLabels
            }
            if let badgePositionString = properties["badgePosition"] as? String {
                lookAroundView.badgePosition = MKLookAroundBadgePosition.fromString(badgePositionString)
            }
            if let POIPointOfInterestFilterMap = properties["POIPointOfInterestFilter"] as? [String: Any] {
                lookAroundView.pointOfInterestFilter = MKPointOfInterestFilter.fromMap(POIPointOfInterestFilterMap)
            }
        }
    }

    private func findParentViewController() -> UIViewController? {
        var responder: UIResponder? = containerView
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }

    func view() -> UIView {
        return containerView
    }

    func deactivate() {
        channel?.setMethodCallHandler(nil)
        lookAroundView?.view.removeFromSuperview()
        lookAroundView?.removeFromParent()
        lookAroundView = nil
        scene = nil
    }

    deinit {
        deactivate()
    }
}

class MapView: NSObject, FlutterPlatformView {
    private var containerView: UIView
    private var channel: FlutterMethodChannel?
    private var errorLabel: UILabel

    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger?) {
        containerView = UIView(frame: frame)
        channel = FlutterMethodChannel(name: "lookaround_view_\(viewId)", binaryMessenger: messenger!)
        errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.textColor = .red
        errorLabel.isHidden = true
        containerView.addSubview(errorLabel)

        // Add constraints to center the label
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            errorLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16)
        ])
        super.init()
        channel?.setMethodCallHandler(handleMethodCall)
        self.notifyLookAroundAvailability(false, "iOS 16.0 or later is required")
        
    }

    func view() -> UIView {
        return containerView
    }

    private func notifyLookAroundAvailability(_ isAvailable: Bool, _ message: String? = nil) {
        let data: [String: Any] = ["isAvailable": isAvailable, "message": message ?? ""]
        channel?.invokeMethod("LookAround#availability", arguments: data)

        // Update the error label based on availability
        if !isAvailable {
            errorLabel.text = message
            errorLabel.isHidden = false
        } else {
            errorLabel.isHidden = true
        }
    }

    private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "LookAround#updateOptions",
            "LookAround#setNavigationEnabled",
            "LookAround#setShowRoadLabels",
            "LookAround#setBadgePosition",
            "LookAround#setPOIPointOfInterestFilter":
            result(FlutterMethodNotImplemented)
            
        case "deactivate":
            deactivate()
            result(nil)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func deactivate() {
        channel?.setMethodCallHandler(nil)
        errorLabel.removeFromSuperview()
    }

}

