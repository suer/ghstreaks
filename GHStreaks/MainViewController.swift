import UIKit

class MainViewController: UIViewController {

    let streaksViewModel = StreaksViewModel()
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
        let refleshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: nil, action: nil)
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let preferenceButton = UIBarButtonItem(title: NSString.awesomeIcon(FaCog), style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        preferenceButton.setTitleTextAttributes(NSDictionary(objects: [UIFont(name: "FontAwesome", size: 20.0)], forKeys: [NSFontAttributeName]), forState: UIControlState.Normal)
        toolbarItems = [refleshButton, spacer, preferenceButton]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

