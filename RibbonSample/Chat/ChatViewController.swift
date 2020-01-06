
import UIKit
import CPaaSSDK
import KMPlaceholderTextView

class ChatViewController: BaseViewController, ChatDelegate,GroupChatDelegate {
    
    @IBOutlet weak var tbBubbleDemo: LynnBubbleTableView!
    @IBOutlet weak var destinationNumber: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatInputView: UIView!
    @IBOutlet weak var inputTextView: KMPlaceholderTextView!
    
    var arrChatTest:Array<LynnBubbleData> = []
    var cpaas: CPaaS!
    var chat_Handler = Chat_Handler()
    let group_Chat_Handler = GroupChat_handler()
    var currentGroup : CPChatGroup!
    var userMe = LynnUserData(userUniqueId: "123", userNickName: "", userProfileImage: nil, additionalInfo: nil)//UIImage(named: "ico_girlprofile")
    var userSomeone = LynnUserData(userUniqueId: "234", userNickName: "", userProfileImage: UIImage(named: "ico_girlprofile"), additionalInfo: nil)
    var viewOpenFromGroup : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarColorForViewController(viewController: self, type: 1, titleString: "CHAT")
        
        //        tbBubbleDemo.bubbleDelegate = self
        tbBubbleDemo.bubbleDataSource = self
        
        destinationNumber.placeholder = "[userId]@[domain]"
        //        destinationNumber.text = "amitg@hcl.z9ht.att.com"
        
        chat_Handler.cpaas = self.cpaas
        chat_Handler.subscribeServices()
        chat_Handler.delegate_CHAT = self
        
        group_Chat_Handler.delegate_Group_Chat = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        inputTextView.layer.cornerRadius = 4.0
        inputTextView.layer.borderColor = UIColor.gray.cgColor
        inputTextView.layer.borderWidth = 0.8
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.viewOpenFromGroup == true) {
            self.tbBubbleDemo.reloadData()
            self.destinationNumber.isHidden = true
            let navigationButton = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(getGroupInfo))
            self.navigationItem.rightBarButtonItem  = navigationButton
        }
    }
    
    @objc func getGroupInfo(){
        let vc  = GroupDetailsViewController(nibName:"GroupDetailsViewController",bundle:nil)
        vc.currentGroup = self.currentGroup
        vc.cpaas = self.cpaas
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        if NetworkState.isConnected() {
            if destinationNumber.isEmpty() && self.viewOpenFromGroup == false{
                DispatchQueue.main.async { () -> Void in
                    LoaderClass.sharedInstance.hideOverlayView()
                    Alert.instance.showAlert(msg: "Please enter Destination UserId.", title: "", sender: self)
                }
            }
            else if inputTextView.text.count == 0 {
                DispatchQueue.main.async { () -> Void in
                    LoaderClass.sharedInstance.hideOverlayView()
                    Alert.instance.showAlert(msg: "Please enter text", title: "", sender: self)
                }
            } else{
                if(self.viewOpenFromGroup == false) {
                    LoaderClass.sharedInstance.showActivityIndicator()
                    chat_Handler.destinationNumber = destinationNumber.text
                    chat_Handler.sendMessage(message:inputTextView.text)
                } else {
                    self.group_Chat_Handler.cpaas = self.cpaas
                    self.group_Chat_Handler.subscribeServices()
                    self.group_Chat_Handler.sendMessageInGroup(messageToBesend: inputTextView.text, chatGroup: self.currentGroup) { (status) in
                        if(status == true) {
                            print("Message Delivered Sucessfully.")
                        } else {
                            print("Message Delivery fail.")
                        }
                    }
                }
            }
        } else{
            DispatchQueue.main.async { () -> Void in
                LoaderClass.sharedInstance.hideOverlayView()
                Alert.instance.showAlert(msg: "No Internet Connection", title: "", sender: self)
            }
        }
    }
    
    // MARK: SmsDelegate methods
    func inboundMessageReceived(message: String, senderNumber: String) {
        DispatchQueue.main.async { () -> Void in
            print("inboundMessageReceived");
            
            self.userSomeone.userNickName = senderNumber
            
            let bubbleData:LynnBubbleData = LynnBubbleData(userData: self.userSomeone, dataOwner: .someone, message: message, messageDate: Date())
            self.arrChatTest.append(bubbleData)
            self.tbBubbleDemo.reloadData()
        }
    }
    
    func deliveryStatusChanged() {
        print("deliveryStatusChanged");
    }
    
    func outboundMessageSent() {
        print("outboundMessageSent");
    }
    func sendMessage(isSuccess: Bool) {
        if isSuccess {
            DispatchQueue.main.async { () -> Void in
                LoaderClass.sharedInstance.hideOverlayView()
                self.userSomeone.userNickName = self.destinationNumber.text
                
                let bubbleData:LynnBubbleData = LynnBubbleData(userData: self.userMe, dataOwner: .me, message: self.inputTextView.text, messageDate: Date())
                self.arrChatTest.append(bubbleData)
                self.tbBubbleDemo.reloadData()
                self.inputTextView.resignFirstResponder()
            }
        } else {
            DispatchQueue.main.async { () -> Void in
                LoaderClass.sharedInstance.hideOverlayView()
                print("Failed to sent message")
                Alert.instance.showAlert(msg: "Failed to sent. Try again later.", title: "", sender: self)
                self.inputTextView.resignFirstResponder()
            }
        }
    }
    
    //Group message delegate
    func outboundGroupMessageSent(){
        DispatchQueue.main.async {
            let bubbleData:LynnBubbleData = LynnBubbleData(userData: self.userMe, dataOwner: .me, message: self.inputTextView.text, messageDate: Date())
            self.arrChatTest.append(bubbleData)
            self.tbBubbleDemo.reloadData()
            print("Group outbound mesage send")
        }
    }
    
    //Group message delegate
    func inboundGroupMessageReceived(message: CPInboundMessage) {
        DispatchQueue.main.async {
            let bubbleData:LynnBubbleData = LynnBubbleData(userData: self.userSomeone, dataOwner: .someone, message: message.value(forKey: "text") as? String, messageDate: (message.value(forKey: "timestamp") as? Date)!)
            self.arrChatTest.append(bubbleData)
            self.tbBubbleDemo.reloadData()
            print("Group outbound mesage send")
        }
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            bottomConstraint?.constant = isKeyboardShowing ? keyboardFrame!.height : 0
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.chatInputView.superview?.setNeedsLayout()
    }
    
    
}

extension ChatViewController: LynnBubbleViewDataSource {
    
    func bubbleTableView(dataAt index: Int, bubbleTableView: LynnBubbleTableView) -> LynnBubbleData {
        return self.arrChatTest[index]
    }
    
    func bubbleTableView(numberOfRows bubbleTableView: LynnBubbleTableView) -> Int {
        return self.arrChatTest.count
    }
}
extension ChatViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("print1")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("print2")
    }
}
