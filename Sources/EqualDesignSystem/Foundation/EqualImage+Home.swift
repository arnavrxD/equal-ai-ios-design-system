// Home / permissions art: iOS system alerts cropped exactly as the Figma permission walkthrough
// shows them (image-fill crops of the bundled screenshots, nodes 20365:41846, 42146, 42210).
import SwiftUI

public extension EqualImage {
    /// iOS alert: "Equal AI (PP)" Would Like to Send You Notifications (300×202 at 1x, radius 30).
    static let iosAlertNotifications = EqualImage("ios-alert-notifications.jpg")
    /// iOS alert: "Equal AI (PP)" would like to access your Contacts (299×263 at 1x, radius 30).
    static let iosAlertContacts = EqualImage("ios-alert-contacts.jpg")
    /// iOS App Tracking Transparency alert (291×328 at 1x, radius 30). The app name is patched in code.
    static let iosAlertTracking = EqualImage("ios-alert-tracking.jpg")
}
