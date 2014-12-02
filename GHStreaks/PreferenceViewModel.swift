class PreferenceViewModel: NSObject {
    let keyOfUser = "GITHUB_USER"
    let keyOfHour = "NOTIFICATION_HOUR"

    dynamic var user: String = ""
    dynamic var hour: String = ""

    override init() {
        super.init()
        load()
    }

    func save() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(user, forKey: keyOfUser)
        userDefaults.setObject(hour, forKey: keyOfHour)
    }

    func load() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        self.user = userDefaults.stringForKey(keyOfUser) ?? ""
        self.hour = userDefaults.stringForKey(keyOfHour) ?? "18:00"
    }

    func getStreaksURL() -> NSURL {
        let baseURL = NSURL(string: getServiceURL())
        return NSURL(string: "/streaks/\(user)", relativeToURL: baseURL)!
    }

    private func getRegisterURL() -> NSURL {
        let baseURL = NSURL(string: getServiceURL())
        return NSURL(string: "/notifications", relativeToURL: baseURL)!
    }

    private func getServiceURL() -> String {
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("preference", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: path!)
        return dictionary!.objectForKey("ServiceURL") as String
    }

    func setUser(user: String) {
        self.user = user
    }

    func setHour(hour: String) {
        self.hour = hour
    }

    func register(#user: String, hour: String, deviceToken: String, success: () -> (), failure: NSException -> ()) {
        let utcOffset = NSTimeZone.defaultTimeZone().secondsFromGMT / 3600
        let params = [
            "notification[name]": user,
            "notification[device_token]": deviceToken,
            "notification[hour]": hour,
            "notification[utc_offset]": String(utcOffset)
        ]
        LRResty.client().post(getRegisterURL().absoluteString, payload: params, withBlock: {
            response in
            if (response as LRRestyResponse).status < 300 {
                success()
            } else {
                failure(NSException(name: "Error", reason: "fail to register", userInfo: nil))
            }
            return
        })
    }
}