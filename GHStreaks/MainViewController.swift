import UIKit

class MainViewController: UIViewController {

    let streaksViewModel = StreaksViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GHStreaks"
        view.backgroundColor = UIColor.whiteColor()
        loadTitleLabel()
        loadStreaksLabel()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

