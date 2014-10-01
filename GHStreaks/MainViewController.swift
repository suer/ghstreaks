import UIKit

class MainViewController: UIViewController {

    let streaksViewModel = StreaksViewModel()
    let preferenceViewModel = PreferenceViewModel()
    var preferenceViewController: PreferenceViewController

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
        loadTitleLabel()
        loadStreaksLabel()
        loadToolBarButton()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: false)
    }

    private func loadTitleLabel() {
        let label = UILabel(frame: CGRectMake(0, 140, view.bounds.width, 30))
        label.text = "Current Streaks"
        label.font = UIFont.systemFontOfSize(30)
        label.textAlignment = NSTextAlignment.Center
        view.addSubview(label)
    }

    private func loadStreaksLabel() {
        let label = UILabel(frame: CGRectMake(0, 200, view.bounds.width, 100))
        label.text = ""
        label.font = UIFont.systemFontOfSize(100)
        label.textAlignment = NSTextAlignment.Center
        view.addSubview(label)
        streaksViewModel.rac_valuesForKeyPath("currentStreaks", observer: streaksViewModel).subscribeNext({
            currentStreaks in
            label.text = String(currentStreaks as Int)
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
            SVProgressHUD.showWithStatus("Getting Streaks", maskType: 3)
            self.streaksViewModel.retrieveStreaks(self.preferenceViewModel.getStreaksURL(),
                success: {
                    SVProgressHUD.showSuccessWithStatus("Success")
                    return
                },
                failure: {
                    exception in
                    NSLog((exception as NSException).reason ?? "cannot get streaks")
                    SVProgressHUD.showErrorWithStatus((exception as NSException).reason)
                    return
                }
            )
            return RACSignal.empty()
        })
        return refreshButton
    }

    private func createPreferenceButton() -> UIBarButtonItem {
        let preferenceButton = UIBarButtonItem(title: NSString.awesomeIcon(FaCog), style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        preferenceButton.setTitleTextAttributes(NSDictionary(objects: [UIFont(name: "FontAwesome", size: 20.0)], forKeys: [NSFontAttributeName]), forState: UIControlState.Normal)
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

