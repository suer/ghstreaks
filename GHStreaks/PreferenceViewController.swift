import UIKit

class PreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    var preferenceViewModel = PreferenceViewModel()
    var hourPickerView: UIPickerView?
    var hourChoices: [String] = []
    var tableView: UITableView = UITableView()
    var userTextField = UITextField()
    var invisibleDateTextField = UITextField()

    let cellHeight = CGFloat(50)

    convenience init(preferenceViewModel: PreferenceViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.preferenceViewModel = preferenceViewModel
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        title = NSLocalizedString("Preference", comment: "")
        view.backgroundColor = UIColor.whiteColor()
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        edgesForExtendedLayout = UIRectEdge.None
        automaticallyAdjustsScrollViewInsets = false
        super.viewDidLoad()
        addHourPickerView()
        addRegisterButton()
        addTableView()
        addNaviagationBarButton()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        preferenceViewModel.load()
        setEnabledForLeftButton()
        userTextField.text = preferenceViewModel.user
        for i in 0..<24 {
            if preferenceViewModel.hour == String(format: "%d:00", i) {
                hourPickerView?.selectRow(i, inComponent: 0, animated: false)
            }
        }
        tableView.reloadData()
    }

    private func addTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: cellHeight * 2),
            NSLayoutConstraint(item: tableView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: tableView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)
            ])

        view.addSubview(invisibleDateTextField)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = NSLocalizedString("User", comment: "")
            cell.contentView.addSubview(userTextField)
            userTextField.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            cell.contentView.addConstraints([
                NSLayoutConstraint(item: userTextField, attribute: .Top, relatedBy: .Equal, toItem: cell.contentView, attribute: .Top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: userTextField, attribute: .Bottom, relatedBy: .Equal, toItem: cell.contentView, attribute: .Bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: userTextField, attribute: .Left, relatedBy: .Equal, toItem: cell.contentView, attribute: .Left, multiplier: 1.0, constant: 100.0),
                NSLayoutConstraint(item: userTextField, attribute: .Right, relatedBy: .Equal, toItem: cell.contentView, attribute: .Right, multiplier: 1.0, constant: -15.0)
                ])
            userTextField.textAlignment = .Right
            userTextField.addTarget(self, action: Selector("userTextChanged"), forControlEvents: .EditingChanged)
            preferenceViewModel.addObserver(self, forKeyPath: "user", options: .New, context: nil)
        case 1:
            cell.textLabel?.text = NSLocalizedString("Notify", comment: "")
            cell.detailTextLabel?.text = preferenceViewModel.hour
            preferenceViewModel.addObserver(self, forKeyPath: "hour", options: .New, context: nil)
        default:
            break
        }
        return cell
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "user" {
            setEnabledForLeftButton()
        } else if keyPath == "hour" {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
            cell?.detailTextLabel?.text = preferenceViewModel.hour
        }
    }

    private func setEnabledForLeftButton() {
        navigationItem.leftBarButtonItem?.enabled = !preferenceViewModel.user.isEmpty
    }

    func userTextChanged() {
        preferenceViewModel.user = userTextField.text ?? ""
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch (indexPath.row) {
        case 0:
            userTextField.becomeFirstResponder()
        case 1:
            invisibleDateTextField.becomeFirstResponder()
        default:
            return
        }
    }

    private func addHourPickerView() {
        hourPickerView = UIPickerView(frame: CGRectMake(0, view.bounds.height, view.bounds.width, 216))
        hourPickerView!.delegate = self
        hourPickerView!.dataSource = self
        invisibleDateTextField.inputView = hourPickerView!

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
        preferenceViewModel.hour = hourChoices[row]
    }

    private func addRegisterButton() {
        let registerButton = UIButton(type: UIButtonType.System)
        registerButton.frame = CGRectMake(10, 250, view.bounds.width, 30)
        registerButton.titleLabel?.textAlignment = .Center
        registerButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        registerButton.setTitle(NSLocalizedString("Register", comment: ""), forState: UIControlState.Normal)
        registerButton.addTarget(self, action: Selector("registerButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(registerButton)

        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: registerButton, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: cellHeight * 3),
            NSLayoutConstraint(item: registerButton, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: cellHeight * 4),
            NSLayoutConstraint(item: registerButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: registerButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)
            ])
    }

    func registerButtonTapped() {
        self.blur()
        SVProgressHUD.showWithStatus(NSLocalizedString("Registering...", comment: ""), maskType: .Black)
        self.preferenceViewModel.register(user: self.preferenceViewModel.user, hour: self.preferenceViewModel.hour, deviceToken: self.getDeviceToken(),
            success: {
                SVProgressHUD.showSuccessWithStatus("Success")
                self.preferenceViewModel.save()
                self.dismissViewControllerAnimated(true, completion: nil)
                return
            },
            failure: {
                exception in
                NSLog((exception as NSException).reason ?? "cannot get streaks")
                SVProgressHUD.showErrorWithStatus((exception as NSException).reason)
                return
            }
        )
    }

    private func addNaviagationBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .Plain, target: self, action: "cancelButtonTapped")
    }

    func cancelButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    private func getDeviceToken() -> String {
        return (UIApplication.sharedApplication().delegate as? AppDelegate)?.deviceToken ?? ""
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        blur()
    }

    private func blur() {
        userTextField.resignFirstResponder()
        invisibleDateTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
