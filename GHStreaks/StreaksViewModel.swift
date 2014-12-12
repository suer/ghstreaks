class StreaksViewModel: NSObject {
    dynamic var currentStreaks = 0
    let KEY_OF_CURRENT_STREAKS = "CURRENT_STREAKS"
    let KEY_OF_RELOAD_TIME = "RELOAD_TIME"
    let expirationMinutes = 10

    override init () {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        currentStreaks = userDefaults.integerForKey(KEY_OF_CURRENT_STREAKS) ?? 0
    }

    func setCurrentStreaks(currentStreaks: Int) {
        self.currentStreaks = currentStreaks
    }

    func retrieveStreaks(url: NSURL, success: () -> (), failure: NSException -> ()) {
        LRResty.client().get(url.absoluteString, withBlock: {
            response in
            let json = (response as LRRestyResponse).asString()
            let jsonData = json.dataUsingEncoding(NSUTF8StringEncoding)
            if jsonData == nil {
                failure(NSException(name: "JSON error", reason: "JSON is nil", userInfo: nil))
            }

            var error: NSError? = nil
            let dic = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary
            if dic == nil || error != nil {
                failure(NSException(name: "JSON error", reason: "fail to parse JSON", userInfo: nil))
            } else {
                self.currentStreaks = dic!.objectForKey("current_streaks") as Int
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setInteger(self.currentStreaks, forKey: self.KEY_OF_CURRENT_STREAKS)
                success()
            }

            return
        })
    }

    func saveReloadTime() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(NSDate(), forKey: KEY_OF_RELOAD_TIME)
    }

    func isExpired() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let reloadTime = userDefaults.objectForKey(KEY_OF_RELOAD_TIME) as? NSDate {
            return abs(reloadTime.timeIntervalSinceNow) > 10 * 60
        }
        return true
    }
}