
import UIKit

class Alert: NSObject {

    static let instance = Alert()

    func showAlert(msg:String , title:String , sender:UIViewController?){
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        sender?.present(alert, animated: true, completion: nil)
    }

    func showAlertWithConfirmation(_ message: String, withTitle title: String, itsController sender: UIViewController?, completion completionBlock: @escaping (_ success: Bool) -> Void) {
        let alrt = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "YES", style: .destructive, handler: {(_ alert: UIAlertAction) -> Void in
            completionBlock(true)
        })
        let Cancel = UIAlertAction(title: "NO", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            completionBlock(false)
        })
        alrt.addAction(ok)
        alrt.addAction(Cancel)
        sender?.present(alrt, animated: true, completion: nil)
    }
    
    /*
    func createVerifyOTPView(model: OTPModel, itsController sender: UIViewController?) -> Void {
        let alertController = UIAlertController(title: "OTP Verification", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Email"
            textField.isSecureTextEntry = false
            textField.keyboardType = UIKeyboardType.emailAddress
            textField.tag = 122
            textField.delegate = sender as? UITextFieldDelegate
        }
        alertController.addTextField { textField in
            textField.placeholder = "OTP Code"
            textField.isSecureTextEntry = false
            textField.keyboardType = UIKeyboardType.default
            textField.tag = 123
            textField.delegate = sender as? UITextFieldDelegate
        }
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textFieldEmail = alertController.textFields?.first, let textFieldCode = alertController.textFields?.last else { return }
            
            if GlobalFunctions.sharedInstance.isValidEmail(testStr: textFieldEmail.text ?? ""){
                print("Valid Email \(String(describing: textFieldEmail.text))")
                
                LoaderClass.sharedInstance.showActivityIndicator()
                
                let userServiceManager = UserServiceManager()
                userServiceManager.forgotPassword(object: model, completionHandler: { (dictData, message, isSuccess) in
                    
                    LoaderClass.sharedInstance.hideOverlayView()
                    if isSuccess{
                        Alert.instance.showAlert(msg: message, title: "Success", sender: sender)
                        
                    }else{
                        Alert.instance.showAlert(msg: message, title: "Error", sender: sender)
                    }
                })
                
            }
            else{
                print("InValid Email \(String(describing: textFieldEmail.text))")
            }
            
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        sender?.present(alertController, animated: true, completion: nil)
    }
    */

    typealias completedBlock = (_ text1:String, _ text2:String ,_ isSuccess:Bool) -> Void

    func showAlertForMessage(withEmail email: String?, withMessage msg: String?, title: String?, for viewController: UIViewController?, withCompletionBlock completionBlock: @escaping completedBlock, withCompletionBlock1 completionBlock1: @escaping completedBlock) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Email"
            textField.isSecureTextEntry = false
            textField.keyboardType = UIKeyboardType.emailAddress
            textField.tag = 122
            textField.text = email
            textField.delegate = viewController as? UITextFieldDelegate
        }
        alert.addTextField { textField in
            textField.placeholder = "OTP Code"
            textField.isSecureTextEntry = false
            textField.keyboardType = UIKeyboardType.default
            textField.tag = 123
            textField.delegate = viewController as? UITextFieldDelegate
        }
        
        let textFieldEmail = alert.textFields?.first
        let textFieldCode = alert.textFields?.last
        
        let defaultAction = UIAlertAction(title: NSLocalizedString("Send", comment: ""), style: .default, handler: { action in
            completionBlock(textFieldEmail?.text ?? "", textFieldCode?.text ?? "", true)
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: { action in
            completionBlock1("", "", false)
        })
        
        
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        viewController?.present(alert, animated: true)
    }
}
