
import UIKit
import CPaaSSDK

class GroupDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate{
    
    var currentGroup : CPChatGroup!
    var groupParticipantsArray = [CPChatGroupParticipant]()
    var cpaas: CPaaS!
    let group_Chat_Handler = GroupChat_handler()

    @objc public var participants:Set<CPChatGroupParticipant> = []

    
    @IBOutlet weak var groupDetailsTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGestureToTableView()
            }
    
    func addGestureToTableView() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        self.groupDetailsTableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.groupDetailsTableView)
        let indexPath = self.groupDetailsTableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            print("Long press on row, at \(indexPath!.row)")
            if(indexPath?.section == 1) {
                self.showAlertForDelete(currentIndex: indexPath!)
            }
        }
    }
    
    func showAlertForDelete(currentIndex:IndexPath) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the user from group?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            self.deleteMember(currentIndex: currentIndex)
        })
        let cancel = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
            print("Cancel button click...")
        }
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func deleteMember(currentIndex:IndexPath) {
        var member:CPChatGroupParticipant!
        if let chatGroup = self.currentGroup {
            let memberArray = Array(chatGroup.participants)
            member = memberArray[currentIndex.row]
        }
        self.group_Chat_Handler.deleteParticipants(chatGroup: self.currentGroup, member: member) { (error) in
            if error == nil {
                Alert.instance.showAlert(msg: "Member deleted Sucessfully.", title: "Alert", sender: self)
            } else {
                Alert.instance.showAlert(msg: "Not able to delete member.", title: "Alert", sender: self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navigationButton = UIBarButtonItem(title: "Add Member", style: .plain, target: self, action: #selector(addMembers))
        self.navigationItem.rightBarButtonItem  = navigationButton
    }
    
    @objc func addMembers(){
        let alertController = UIAlertController(title: "Title", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "[userId]@[domain]"
        }
        
        let saveAction = UIAlertAction(title: "Confirm", style: .default, handler: { alert -> Void in
            if let textField = alertController.textFields?[0] {
                if textField.text!.count > 0 {
                    print("Text :: \(textField.text ?? "")")
                    self.submitAction(groupMemberAddress: textField.text!)
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.preferredAction = saveAction
        self.present(alertController, animated: true, completion: nil)
    }
    
    func submitAction(groupMemberAddress:String){
                self.group_Chat_Handler.cpaas = self.cpaas
                self.group_Chat_Handler.subscribeServices()
                let memberAddress : String = groupMemberAddress
                let memberStatus : Bool = false
        self.group_Chat_Handler.addParticipants(chatGroup: self.currentGroup,memberAddress: memberAddress, memberStatus: memberStatus) { (error) in
                    if error == nil {
                        Alert.instance.showAlert(msg: "Member added Sucessfully.", title: "Alert", sender: self)
                    } else {
                        Alert.instance.showAlert(msg: "Not able to add member.", title: "Alert", sender: self)
                    }
                }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return 2
        } else {
           return self.currentGroup.participants.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Groups")
        if(indexPath.section == 0) {
            if(indexPath.row == 0) {
                let groupName : String = "Group Name --> "
                cell.textLabel?.text = groupName + (currentGroup.value(forKey: "name") as! String)
                cell.detailTextLabel?.text = groupName + (currentGroup.value(forKey: "status") as! String)
            } else {
                let groupSubject : String = "Subject --> "
                if((currentGroup.value(forKey: "subject") as? String) != nil) {
                    cell.textLabel?.text = groupSubject + (currentGroup.value(forKey: "subject") as! String)
                }
            }
        } else {
            var member:CPChatGroupParticipant!
            if let chatGroup = self.currentGroup {
                let memberArray = Array(chatGroup.participants)
                member = memberArray[indexPath.row]
            } else {
                // working on in-progress new group
            }
            
            cell.textLabel?.text = member.address
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionName: String
        switch section {
        case 0:
            sectionName = NSLocalizedString("Group Details", comment: "groupDetails")
        case 1:
            sectionName = NSLocalizedString("Participants", comment: "groupParticipants")
        default:
            sectionName = ""
        }
        return sectionName
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
