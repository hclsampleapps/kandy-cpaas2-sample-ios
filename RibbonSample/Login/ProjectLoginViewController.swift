
import UIKit
import CPaaSSDK

class ProjectLoginViewController: BaseViewController {
    
    @IBOutlet weak var container_View: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var privateprojectkey_Field: UITextField!
    @IBOutlet weak var privateprojectsecret_Field: UITextField!
    @IBOutlet weak var baseUrl_Field: UITextField!
    
    @IBOutlet weak var privateprojectkey_View: UIView!
    @IBOutlet weak var privateprojectsecret_View: UIView!
    @IBOutlet weak var baseUrl_View: UIView!
    
    var idToken : String!
    var accessToken : String!
    var lifeTime : Int = 3600
    var channelInfo : String!
    
    var currentTextField: UITextField!    
    var cpaas: CPaaS!
    var authentication: CPAuthenticationService {
        get {
            return self.cpaas.authenticationService
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.privateprojectkey_Field.text = "PRIV-nesonukuv.34mv.nesoproject1"
        self.baseUrl_Field.text = "oauth-cpaas.att.com" ////"nvs-cpaas-oauth.kandy.io"
        self.privateprojectsecret_Field.text =  "8fe371a7-8158-4800-bb98-ca3ed7291816"
        
        self.setNavigationBarColorForViewController(viewController: self, type: 0, titleString: "Client Credentials")
        NotificationCenter.default.addObserver(self, selector: #selector(ProjectLoginViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProjectLoginViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        changeViewLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension ProjectLoginViewController{
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        
        if self.privateprojectkey_Field.isEmpty(){
            Alert.instance.showAlert(msg: "Enter valid private project key", title: "Error", sender: self)
            return
        }
        
        if self.privateprojectsecret_Field.isEmpty(){
            Alert.instance.showAlert(msg: "Enter valid private project secret", title: "Error", sender: self)
            return
        }
        
        LoaderClass.sharedInstance.showActivityIndicator()
        
        let model = ProjectLoginModel()
        model.privateprojectkey = self.privateprojectkey_Field.text
        model.privateprojectsecret = self.privateprojectsecret_Field.text
        model.grant_type = "client_credentials"
        model.scope = "openid regular_call"
        
        if NetworkState.isConnected(){
            let userServiceManager = UserServiceManager()
            userServiceManager.loginUserProject(object: model) { (json) in
                
                DispatchQueue.main.async { () -> Void in
                    LoaderClass.sharedInstance.hideOverlayView()
                    
                    guard let response = json else{
                        UserDefaultsClass.sharedInstance.setIsUserLoggedIn(isLoggedIn: false)
                        Alert.instance.showAlert(msg: "No data found.", title: "Error", sender: self)
                        return
                    }
                    
                    let loginModel = AuthenticationModel.init(json: response)
                    
                    if loginModel.id_token == "", loginModel.access_token == ""{
                        LoaderClass.sharedInstance.hideOverlayView()
                        Alert.instance.showAlert(msg:"Failed", title: "Error", sender: self)
                        return
                    }else{
                        
                        self.idToken = loginModel.id_token
                        self.accessToken = loginModel.access_token
                        self.setConfig()
                        self.subscribeServices()
                        self.setToken()
                    }
                }
                
            }
        }else{
            DispatchQueue.main.async { () -> Void in
                LoaderClass.sharedInstance.hideOverlayView()
                Alert.instance.showAlert(msg: "No Internet Connection", title: "", sender: self)
            }
        }
    }
}

extension ProjectLoginViewController {
    
    func setConfig() {
        let configuration = CPConfig.sharedInstance()
        configuration.restServerUrl = self.baseUrl_Field.text ?? "oauth-cpaas.att.com"  //"nvs-cpaas-oauth.kandy.io"
        configuration.useSecureConnection = true
    }
    
    func subscribeServices() {
        self.cpaas = CPaaS(services:[CPServiceInfo(type: .sms, push: true), CPServiceInfo(type: .chat, push: true),CPServiceInfo(type: .call, push: true), CPServiceInfo(type: .presence, push: false), CPServiceInfo(type: .addressbook, push: true)])
    }
    
    func setToken() {
        LoaderClass.sharedInstance.showActivityIndicator()
        
        print(self.idToken);
        print(self.accessToken);
        
        self.authentication.connect(idToken: self.idToken, accessToken: self.accessToken, lifetime: self.lifeTime) { (error, channelInfo) in
            
            if let error = error {
                DispatchQueue.main.async { () -> Void in
                    LoaderClass.sharedInstance.hideOverlayView()
                    print(error.localizedDescription)
                }
            } else {
                DispatchQueue.main.async { () -> Void in
                    LoaderClass.sharedInstance.hideOverlayView()
                    self.channelInfo = channelInfo!
                    print("Channel Info " + self.channelInfo)
                    
                    // Navigate To Dashboard
                    self.navigateToDashboard()
                }
            }
        }
    }
    
    func navigateToDashboard() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let vc  = DashboardViewController(nibName:"DashboardViewController",bundle:nil)
        
        let navigationController = UINavigationController.init(rootViewController: vc)
        
        vc.cpaas = self.cpaas
        appDelegate?.window?.rootViewController = navigationController
    }
}

extension ProjectLoginViewController{
    func changeViewLayout() {
        privateprojectkey_View.layer.cornerRadius = 4.0
        privateprojectkey_View.layer.borderColor = UIColor.gray.cgColor
        privateprojectkey_View.layer.borderWidth = 0.8
        
        privateprojectsecret_View.layer.cornerRadius = 4.0
        privateprojectsecret_View.layer.borderColor = UIColor.gray.cgColor
        privateprojectsecret_View.layer.borderWidth = 0.8
        
        baseUrl_View.layer.cornerRadius = 4.0
        baseUrl_View.layer.borderColor = UIColor.gray.cgColor
        baseUrl_View.layer.borderWidth = 0.8
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let currentView = self.view.viewWithTag(currentTextField.tag-1900) {
            let kbrect: CGRect? = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let heightOffset: CGFloat = scrollView.frame.origin.y + container_View.frame.origin.y + currentView.frame.origin.y + currentView.frame.size.height + 60
            
            if heightOffset > (kbrect?.origin.y ?? 00) {
                scrollView.isScrollEnabled = true
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.3)
                scrollView.contentOffset = CGPoint(x: 0, y: heightOffset - (kbrect?.origin.y)! )
                UIView.commitAnimations()
            } else {
                scrollView.isScrollEnabled = false
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        UIView.commitAnimations()
        
        self.scrollView.isScrollEnabled = false
    }
}



extension ProjectLoginViewController :UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
