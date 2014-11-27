import UIKit

class MainViewController: UIViewController {

    let streaksViewModel = StreaksViewModel()
    let preferenceViewModel = PreferenceViewModel()
    var preferenceViewController: PreferenceViewController
    let titleLabel = UILabel()
    let streaksLabel = UILabel()

    convenience override init() {
        self.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.preferenceViewController = PreferenceViewController(preferenceViewModel: preferenceViewModel)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GHStreaks"
        view.backgroundColor = UIColor.whiteColor()
        view.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        loadTitleLabel()
        loadStreaksLabel()
        loadToolBarButton()
        if preferenceViewModel.user.isEmpty {
            navigationController?.pushViewController(preferenceViewController, animated: false)
        }
        addNotificationObserver()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: false)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        reload()
    }

    private func loadTitleLabel() {
        titleLabel.text = "Current Streaks"
        titleLabel.font = UIFont.systemFontOfSize(30)
        titleLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(titleLabel)

        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        let top = view.bounds.height / 5
        view.addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: top),
            NSLayoutConstraint(item: titleLabel, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: top + 30.0),
            NSLayoutConstraint(item: titleLabel, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: titleLabel, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)
            ])
    }

    private func loadStreaksLabel() {
        streaksLabel.text = ""
        streaksLabel.font = UIFont.systemFontOfSize(100)
        streaksLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(streaksLabel)

        streaksLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraints([
            NSLayoutConstraint(item: streaksLabel, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Top, multiplier: 1.0, constant: 30.0),
            NSLayoutConstraint(item: streaksLabel, attribute: .Bottom, relatedBy: .Equal, toItem: titleLabel, attribute: .Top, multiplier: 1.0, constant: 130.0),
            NSLayoutConstraint(item: streaksLabel, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: streaksLabel, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)
            ])

        streaksViewModel.rac_valuesForKeyPath("currentStreaks", observer: streaksViewModel).subscribeNext({
            currentStreaks in
            self.streaksLabel.text = String(currentStreaks as Int)
            return
        })
    }

    private func loadToolBarButton() {
        let refreshButton = createRefreshButton()

        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)

        let preferenceButton = createPreferenceButton()

        toolbarItems = [refreshButton, spacer, preferenceButton]
    }

    private func createRefreshButton() -> UIBarButtonItem {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: nil, action: nil)
        refreshButton.rac_command = RACCommand(signalBlock: {
            input in
            self.reload()
            return RACSignal.empty()
        })
        return refreshButton
    }

    func addNotificationObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActive:"), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    func applicationDidBecomeActive(notification: NSNotification) {
        reload()
    }

    private func reload() {
        SVProgressHUD.showWithStatus(NSLocalizedString("Getting Streaks", comment: ""), maskType: 3)
        self.streaksViewModel.retrieveStreaks(self.preferenceViewModel.getStreaksURL(),
            success: {
                SVProgressHUD.showSuccessWithStatus("Success")
                UIApplication.sharedApplication().applicationIconBadgeNumber = self.streaksViewModel.currentStreaks
                return
            },
            failure: {
                exception in
                NSLog((exception as NSException).reason ?? NSLocalizedString("cannot get streaks", comment: ""))
                SVProgressHUD.showErrorWithStatus((exception as NSException).reason)
                return
            }
        )
    }

    private func createPreferenceButton() -> UIBarButtonItem {
        let preferenceButton = UIBarButtonItem(title: NSString.awesomeIcon(FaCog), style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        let font = UIFont(name: "FontAwesome", size: 20.0)
        let dictionary = NSDictionary(object: font!, forKey: NSFontAttributeName)
        preferenceButton.setTitleTextAttributes(dictionary, forState: UIControlState.Normal)
        preferenceButton.rac_command = RACCommand(signalBlock: {
            input in
            self.navigationController?.pushViewController(self.preferenceViewController, animated: true)
            return RACSignal.empty()
        })
        return preferenceButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

