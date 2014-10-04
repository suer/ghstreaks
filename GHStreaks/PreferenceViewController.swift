import UIKit

class PreferenceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var preferenceViewModel = PreferenceViewModel()
    var userNameTextField: UITextField?
    var hourTextField: UITextField?
    var hourPickerView: UIPickerView?
    var hourChoices: [String] = []

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
        title = NSLocalizedString("Preference", comment: "")
        view.backgroundColor = UIColor.whiteColor()
        super.viewDidLoad()
        addUserNameTextField()
        addHourTextField()
        addHourPickerView()
        addRegisterButton()
        addGestureRecognizer()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField!.text = preferenceViewModel.user
        hourTextField!.text = preferenceViewModel.hour
        for i in 0..<24 {
            if hourTextField!.text == String(format: "%d:00", i) {
                hourPickerView?.selectRow(i, inComponent: 0, animated: false)
            }
        }
    }
    
    private func addUserNameTextField() {
        let userNameLabel = UILabel(frame: CGRectMake(10, 120, 70, 40))
        userNameLabel.text = NSLocalizedString("User", comment: "")
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
        hourLabel.text = NSLocalizedString("Notify", comment: "")
        hourLabel.textAlignment = .Right
        view.addSubview(hourLabel)

        hourTextField = UITextField(frame: CGRectMake(100, 180, 210, 40))
        hourTextField!.text = preferenceViewModel.hour
        hourTextField!.placeholder = "18:00"
        hourTextField!.borderStyle = UITextBorderStyle.RoundedRect
        view.addSubview(hourTextField!)
    }

    private func addHourPickerView() {
        hourPickerView = UIPickerView(frame: CGRectMake(0, view.bounds.height, view.bounds.width, 216))
        hourPickerView!.delegate = self
        hourPickerView!.dataSource = self
        hourTextField!.inputView = hourPickerView!

        for i in 0..<24 {
            hourChoices.append(String(format: "%d:00", i))
        }
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hourChoices.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return hourChoices[row]
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hourTextField!.text = hourChoices[row]
    }

    private func addRegisterButton() {
        let registerButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        registerButton.frame = CGRectMake(10, 250, view.bounds.width, 30)
        registerButton.titleLabel?.textAlignment = .Center
        registerButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        registerButton.setTitle(NSLocalizedString("Register", comment: ""), forState: UIControlState.Normal)
        view.addSubview(registerButton)

        registerButton.rac_command = RACCommand(signalBlock: {
            input in
            SVProgressHUD.showWithStatus(NSLocalizedString("Registering...", comment: ""), maskType: 3)
            self.preferenceViewModel.register(user: self.userNameTextField!.text, hour: self.hourTextField!.text, deviceToken: self.getDeviceToken(),
                success: {
                    SVProgressHUD.showSuccessWithStatus("Success")
                    self.preferenceViewModel.setUser(self.userNameTextField!.text)
                    self.preferenceViewModel.setHour(self.hourTextField!.text)
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

    func addGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("closeSoftwareKeyboard"))
        view.addGestureRecognizer(gestureRecognizer)
    }

    func closeSoftwareKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
