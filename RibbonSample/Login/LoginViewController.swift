
import UIKit
import CPaaSSDK

class LoginViewController: BaseViewController,CPLoggingDelegate {
    

    @IBOutlet weak var container_View: UIView!
    @IBOutlet weak var scrollVw: UIScrollView!
    
    @IBOutlet weak var login_Button: UIButton!
    
    @IBOutlet weak var email_Field: UITextField!
    @IBOutlet weak var clientId_Field: UITextField!
    @IBOutlet weak var password_Field: UITextField!
    @IBOutlet weak var baseUrl_Field: UITextField!
    @IBOutlet weak var clientId_View: UIView!
    @IBOutlet weak var email_View: UIView!
    @IBOutlet weak var password_View: UIView!
    @IBOutlet weak var baseUrl_View: UIView!
    
    var currentTextField: UITextField!
    
    var idToken : String!
    var accessToken : String!
    var lifeTime : Int = 3600
    var channelInfo : String!
    
    var cpaas: CPaaS!
    var authentication: CPAuthenticationService {
        get {
            return self.cpaas.authenticationService
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hardcoded Values
        self.clientId_Field.text = "PUB-project.name"
        self.email_Field.text =  "user2@domain.com"
        self.password_Field.text = "Test@123"
        self.baseUrl_Field.text = "baseurl.domain.com"
        
        self.setNavigationBarColorForViewController(viewController: self, type: 0, titleString: "Password Grant")
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        changeViewLayout()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension LoginViewController{
    func changeViewLayout() {
        email_View.layer.cornerRadius = 4.0
        email_View.layer.borderColor = UIColor.gray.cgColor
        email_View.layer.borderWidth = 0.8
        
        password_View.layer.cornerRadius = 4.0
        password_View.layer.borderColor = UIColor.gray.cgColor
        password_View.layer.borderWidth = 0.8
        
        clientId_View.layer.cornerRadius = 4.0
        clientId_View.layer.borderColor = UIColor.gray.cgColor
        clientId_View.layer.borderWidth = 0.8
        
        baseUrl_View.layer.cornerRadius = 4.0
        baseUrl_View.layer.borderColor = UIColor.gray.cgColor
        baseUrl_View.layer.borderWidth = 0.8
        
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let currentView = self.view.viewWithTag(currentTextField.tag-900) {
            let kbrect: CGRect? = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let heightOffset: CGFloat = scrollVw.frame.origin.y + container_View.frame.origin.y + currentView.frame.origin.y + currentView.frame.size.height + 60
            
            if heightOffset > (kbrect?.origin.y ?? 00) {
                scrollVw.isScrollEnabled = true
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.3)
                scrollVw.contentOffset = CGPoint(x: 0, y: heightOffset - (kbrect?.origin.y)! )
                UIView.commitAnimations()
            } else {
                scrollVw.isScrollEnabled = false
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        scrollVw.contentOffset = CGPoint(x: 0, y: 0)
        UIView.commitAnimations()
        
        self.scrollVw.isScrollEnabled = false
    }
}

extension LoginViewController{
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        
        if self.clientId_Field.isEmpty(){
            Alert.instance.showAlert(msg: "Enter valid Client ID", title: "Error", sender: self)
            return
        }
        
        if self.email_Field.isEmpty(){
            Alert.instance.showAlert(msg: "Enter valid Email ID", title: "Error", sender: self)
            return
        }
        
        if !GlobalFunctions.sharedInstance.isValidEmail(testStr: self.email_Field.text ?? ""){
            Alert.instance.showAlert(msg: "Enter valid EmailId", title: "Error", sender: self)
            return
        }
        
        if self.password_Field.isEmpty(){
            Alert.instance.showAlert(msg: "Enter Password", title: "Error", sender: self)
            return
        }
        
        if self.baseUrl_Field.isEmpty(){
            Alert.instance.showAlert(msg: "Enter valid Base Url", title: "Error", sender: self)
            return
        }
        
        LoaderClass.sharedInstance.showActivityIndicator()
        
        let model = LoginModel()
        model.clientId = self.clientId_Field.text
        model.emailId = self.email_Field.text
        model.password =  self.password_Field.text
        model.grant_type = "password"
        model.scope = "openid"

        var appDelegate: AppDelegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.loggedInuserEmail = model.emailId
        
        if NetworkState.isConnected(){
            let userServiceManager = UserServiceManager()
            userServiceManager.loginUser(object: model) { (json) in
                
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
                        UserDefaultsClass.sharedInstance.setIsUserLoggedIn(isLoggedIn: true)
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


//MARK:- UITextFieldDelegate....
extension LoginViewController :UITextFieldDelegate {
    
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

extension LoginViewController {
    
    func setConfig() {

        let configuration = CPConfig.sharedInstance()
        configuration.restServerUrl = "oauth-cpaas.att.com"
        configuration.logManager.delegate = self
        
        configuration.iceCollectionTimeout = 12
        configuration.iceOption = .vanilla

        // Setting ICE Servers
        let iceServers: CPICEServers = CPICEServers()
        iceServers.addICEServer("turns:turn-ucc-1.genband.com:443?transport=tcp")
        iceServers.addICEServer("turns:turn-ucc-2.genband.com:443?transport=tcp")
        iceServers.addICEServer("stun:turn-ucc-1.genband.com:3478?transport=udp")
        iceServers.addICEServer("stun:turn-ucc-2.genband.com:3478?transport=udp")
        configuration.iceServers = iceServers
    }
    
    func log(_ logLevel: CPLogLevel, withLogContext logContext: String, withMethodName methodName: Selector?, withMessage logMessage: String) {
        print("logLevel ",logLevel,"MethodName ",methodName! ,"logMessage ",logMessage)
    }
    
    func subscribeServices() {
        self.cpaas = CPaaS(services:[CPServiceInfo(type: .sms, push: true), CPServiceInfo(type: .chat, push: true),CPServiceInfo(type: .call, push: true), CPServiceInfo(type: .presence, push: false), CPServiceInfo(type: .addressbook, push: true)])
    }
    
    func setToken() {
        LoaderClass.sharedInstance.showActivityIndicator()
        
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
