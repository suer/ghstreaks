import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var deviceToken = ""

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        registerNotification(application)
        let navigationController = UINavigationController(rootViewController: MainViewController())
        window!.addSubview(navigationController.view)
        window!.rootViewController = navigationController
        return true
    }

    private func registerNotification(application: UIApplication) {
        if application.respondsToSelector(Selector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: (UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge), categories: nil))
            application.registerForRemoteNotifications()
        } else {
            application.registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound | UIRemoteNotificationType.Alert)
        }
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        self.deviceToken = (deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet(characterSet)
            .stringByReplacingOccurrencesOfString(" ", withString: "") as String
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        NSLog("Couldn't register: \(error)")
    }
}

