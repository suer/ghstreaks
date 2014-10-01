class StreaksViewModel: RVMViewModel {
    dynamic var currentStreaks = 0
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
                success()
            }

            return
        })
    }
}