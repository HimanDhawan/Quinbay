//
//  SearchedProductTableViewCell.swift
//  Quinbay
//
//  Created by Himan Dhawan on 10/01/22.
//

import UIKit
import SDWebImage

protocol SearchedProductTableViewCellDelegate : AnyObject {
    func addToCartTapped()
}

class SearchedProductTableViewCell: UITableViewCell {

    /// Delegate
    weak var delegate : SearchedProductTableViewCellDelegate?
    
    /// IBOutlets
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var storeInformation: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var discountOuterView: UIView!
    @IBOutlet weak var productDiscount: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        discountOuterView.layer.cornerRadius = discountOuterView.frame.size.height/2
        discountOuterView.layer.masksToBounds = true
    }
    
    func loadCellWithData(data : Product) {
        self.productName.text = data.name
        self.productPrice.text = data.price.offerPriceDisplay
        self.storeInformation.text = data.location
        self.productDiscount.text = ""
        if let strikeThroughPriceDisplay = data.price.strikeThroughPriceDisplay {
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "\(strikeThroughPriceDisplay)")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            
            self.productDiscount.attributedText = attributeString
            discountOuterView.isHidden = false
            self.discountLabel.text = "\(data.price.discount)%"
        } else {
            discountOuterView.isHidden = true
            self.productDiscount.text = ""
            self.discountLabel.text = ""
        }
        
        
        self.rating.text = "\(data.review.rating) (\(data.review.count))"
        
        if let image =  data.images.first, let url = URL.init(string: image) {
            self.productImage.sd_setImage(with: url, placeholderImage: UIImage.init(named: "Unknown"), options: .continueInBackground, context: nil)
        } else {
            productImage.image = UIImage.init(named: "Unknown")
        }
        
        
    }

    @IBAction func addToBagButtonPressed(_ sender: UIButton) {
        self.delegate?.addToCartTapped()
    }
}
