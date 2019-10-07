
import UIKit

class DashboardTypeCustomCollectionCell: UICollectionViewCell {
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgBg: UIImageView!
    @IBOutlet var imgPreview1: UIImageView!
    
    func displayContent(image: UIImage, title: String)
    {
        lblName.text = title
        imgPreview1.image = image
    }
}
