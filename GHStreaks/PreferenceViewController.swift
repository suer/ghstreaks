import UIKit

class PreferenceViewController: UIViewController {

    var preferenceViewModel = PreferenceViewModel()
    var userNameTextField: UITextField?
    var hourTextField: UITextField?
    convenience init(preferenceViewModel: PreferenceViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.preferenceViewModel = preferenceViewModel
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        title = "Preference"
        view.backgroundColor = UIColor.whiteColor()
        super.viewDidLoad()
        addUserNameTextField()
        addHourTextField()
        addRegisterButton()
    }

    private func addUserNameTextField() {
        let userNameLabel = UILabel(frame: CGRectMake(10, 120, 70, 40))
        userNameLabel.text = "User"
        userNameLabel.textAlignment = .Right
        view.addSubview(userNameLabel)

        userNameTextField = UITextField(frame: CGRectMake(100, 120, 210, 40))
        userNameTextField!.text = preferenceViewModel.user
        userNameTextField!.placeholder = "Github User Name"
        userNameTextField!.borderStyle = UITextBorderStyle.RoundedRect
        view.addSubview(userNameTextField!)
    }

    private func addHourTextField() {
        let hourLabel = UILabel(frame: CGRectMake(10, 180, 70, 40))
        hourLabel.text = "Notify"
        hourLabel.textAlignment = .Right
        view.addSubview(hourLabel)

        hourTextField = UITextField(frame: CGRectMake(100, 180, 210, 40))
        hourTextField!.text = preferenceViewModel.hour
        hourTextField!.placeholder = "18:00"
        hourTextField!.borderStyle = UITextBorderStyle.RoundedRect
        view.addSubview(hourTextField!)
    }

    private func addRegisterButton() {
        let registerButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        registerButton.frame = CGRectMake(10, 250, view.bounds.width, 30)
        registerButton.titleLabel?.textAlignment = .Center
        registerButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        registerButton.setTitle("Register", forState: UIControlState.Normal)
        view.addSubview(registerButton)

        registerButton.rac_command = RACCommand(signalBlock: {
            input in
            SVProgressHUD.showWithStatus("Registering...", maskType: 3)
            self.preferenceViewModel.register(user: self.userNameTextField!.text, hour: self.hourTextField!.text, deviceToken: self.getDeviceToken(),
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
    }

    private func getDeviceToken() -> String {
        return (UIApplication.sharedApplication().delegate as? AppDelegate)?.deviceToken ?? ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
