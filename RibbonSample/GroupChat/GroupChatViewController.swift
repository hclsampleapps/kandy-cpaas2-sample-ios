
import UIKit
import CPaaSSDK

class GroupChatViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var groupListTableView : UITableView!
    var cpaas: CPaaS!
    var groupList = [CPChatGroup]()
    let vc = GroupChat_handler()
    let chatViewControllerObject  = ChatViewController(nibName:"ChatViewController",bundle:nil)

    var userMe = LynnUserData(userUniqueId: "123", userNickName: "", userProfileImage: nil, additionalInfo: nil)//UIImage(named: "ico_girlprofile")
    var userSomeone = LynnUserData(userUniqueId: "234", userNickName: "", userProfileImage: UIImage(named: "ico_girlprofile"), additionalInfo: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getGroupList()
        // Do any additional setup after loading the view.
    }
    
    func getGroupList() {
        vc.cpaas = self.cpaas
        vc.subscribeServices()
        vc.getGroupsConversationList { (results) in
                if(results != nil) {
                    self.parseGroupList(results: results!)
                }
            }
    }
    
    func parseGroupList(results:FetchResult) {
            var fetchGroups = [FetchedObjects]()
            fetchGroups = results.result!
            var count = fetchGroups.count
            for currentGroup in fetchGroups {
                self.vc.fetchGroupWithgroupId(groupId: currentGroup.value(forKey: "participant") as! String, handler: { (group) in
                    if(group != nil) {
                        count = count - 1
                        self.groupList.append(group!)
                        DispatchQueue.main.async {
                            self.groupListTableView.reloadData()
                        }
                    }
                })
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(groupList.count > 0) {
             return groupList.count
        } else {
            return 0
        }        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Groups")
        if(self.groupList.count > 0) {
            let groupValue : CPChatGroup = self.groupList[indexPath.row]
            cell.textLabel?.text = groupValue.name
        } else {
            cell.textLabel?.text = "No value"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupValue : CPChatGroup = self.groupList[indexPath.row]
        vc.fetchMessages(count: 20, chatGroup: groupValue) { (results) in
            if(results != nil && results!.result!.count > 0) {
                self.chatViewControllerObject.currentGroup = groupValue
                self.moveToChatView(conversationResults: results!)
            } else {
                Alert.instance.showAlert(msg: "No chat available in this group.", title: "Alert", sender: self)
                self.resignFirstResponder()
            }
        }
    }
    
    func moveToChatView(conversationResults:FetchResult) {
        self.chatViewControllerObject.arrChatTest.removeAll()
        var appDelegate: AppDelegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        for message in conversationResults.result! {
            let msg: CPMessage = message as! CPMessage
            let bubbleData:LynnBubbleData
            appDelegate.loggedInuserEmail.until("@")
            var sender : String = msg.value(forKey: "sender") as! String
            sender.until("@")
            if(appDelegate.loggedInuserEmail.isEqualToString(find: sender)) {
                bubbleData = LynnBubbleData(userData: self.userMe, dataOwner: .me, message: msg.value(forKey: "text") as? String,messageDate: msg.value(forKey: "timestamp") as! Date)
            } else {
                 bubbleData = LynnBubbleData(userData: self.userMe, dataOwner: .someone, message: msg.value(forKey: "text") as? String,messageDate: msg.value(forKey: "timestamp") as! Date)
            }
            self.chatViewControllerObject.arrChatTest.append(bubbleData)
        }
        
        self.chatViewControllerObject.cpaas = self.cpaas
        self.chatViewControllerObject.viewOpenFromGroup = true
        self.navigationController?.pushViewController(chatViewControllerObject, animated: true)
        
    }
    
    func UTCToLocal(date:Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateString = date.toString(dateFormat: "H:mm:ss")
        let dt = dateFormatter.date(from: dateString)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
        return dt!
    }
    
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

extension String {
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
}

extension String {
    mutating func until(_ string: String) {
        var components = self.components(separatedBy: string)
        self = components[0]
    }
}
