
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the vi ew.
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    func setNavigationBarColorForViewController(viewController: UIViewController, type: NSInteger, titleString: String) -> Void {
        
        let viewBg = UIView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:64))
        viewBg.backgroundColor = AppColor.applicationColor
        
        UIGraphicsBeginImageContextWithOptions(viewBg.bounds.size, false, 0)
        let ctx = UIGraphicsGetCurrentContext();
        ctx!.fill(viewBg.bounds)
        viewBg.layer.render(in: ctx!)
        let tempImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        viewController.navigationController?.navigationBar .setBackgroundImage(tempImage, for: UIBarMetrics.default)
        
        let titleLabel = UILabel.init(frame: CGRect(x:(viewBg.frame.size.width/2)-25, y:14.5, width:50, height:35))
        titleLabel.text = titleString
        titleLabel.textColor = UIColor.white
        titleLabel.contentMode = UIView.ContentMode.scaleAspectFit
        viewController.navigationItem.titleView = titleLabel

        if type == 1 {
            let button = UIButton(type:UIButton.ButtonType.custom)
            button.backgroundColor = UIColor.clear
            button.setTitle("", for: .normal)
            button.setImage(UIImage.init(named: "back"), for: UIControl.State.normal)//
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action:#selector(backButtonTapped), for: .touchUpInside)
            
            let leftBarButton = UIBarButtonItem.init(customView: button)
            viewController.navigationItem.leftBarButtonItem = leftBarButton
        }
        else if type == 2 {
            let button = UIButton(type:UIButton.ButtonType.custom)
            button.backgroundColor = UIColor.clear
            button.setTitle("", for: .normal)
            button.setImage(UIImage.init(named: "menu"), for: UIControl.State.normal)//back
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action:#selector(backMenuTapped), for: .touchUpInside)
            
            let leftBarButton = UIBarButtonItem.init(customView: button)
            viewController.navigationItem.leftBarButtonItem = leftBarButton
        }
        else
        {
        }
    }
    
    @objc func backButtonTapped() -> Void {
        if self.navigationController?.popViewController(animated: true) == nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func backMenuTapped() -> Void {

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

