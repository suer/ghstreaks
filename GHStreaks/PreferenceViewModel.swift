class PreferenceViewModel: RVMViewModel {
    var user: String {
        get {
            return "suer"
        }
    }

    func getStreaksURL() -> NSURL {
        let baseURL = NSURL(string: getServiceURL())
        return NSURL(string: "/streaks/\(user)", relativeToURL: baseURL)
    }

    private func getServiceURL() -> String {
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("preference", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: path!)
        return dictionary.objectForKey("ServiceURL") as String
    }
}