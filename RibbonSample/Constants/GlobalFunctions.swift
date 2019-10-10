
import UIKit

class GlobalFunctions: NSObject {
    
    static let sharedInstance = GlobalFunctions()
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func getDocumentDirectory() -> NSURL{
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
        return documentsDirectoryPath
    }
    
    func getStatusColor(status:String) -> UIColor
    {
        if status == "Available" {return .green}
        else if status == "Busy"{return .red}
        else if status == "Away"{return .red}
        else if status == "Vcation" {return .red}
        else {return .yellow}
    }
}



extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setupp()
    }
    
    func setupp() {
        let size = self.font!.pointSize*widthFactor
        self.font = UIFont.init(name: self.font!.fontName, size: size)
    }
    
    func isEmpty() ->Bool{
        guard var txxt = self.text else {return true}
        txxt = txxt.trimmingCharacters(in: .whitespaces)
        if txxt == "" || txxt.count == 0{
            return true
        }
        return false
    }
}

extension UILabel {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setupp()
    }
    
    func setupp() {
        let size = self.font!.pointSize*widthFactor
        self.font = UIFont.init(name: self.font!.fontName, size: size)
    }
    
    func isEmpty() ->Bool{
        guard var txxt = self.text else {return true}
        txxt = txxt.trimmingCharacters(in: .whitespaces)
        if txxt == "" || txxt.count == 0{
            return true
        }
        return false
    }
}

extension UILabel {
    
    @IBInspectable var isShadowOnText: Bool {
        get {
            return self.isShadowOnText
        }
        set {
            guard (newValue as? Bool) != nil else {
                return
            }
            
            if newValue == true{
                
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowRadius = 2.0
                self.layer.shadowOpacity = 1.0
                self.layer.shadowOffset = CGSize(width: 2, height: 2)
                self.layer.masksToBounds = false
            }
        }
    }
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width) 
    }
}
