//
//  SwapItemsTableViewCell.swift
//  swap
//
//  Created by Mohammad Arish Khan on 13/01/22.
//

import UIKit
protocol SwapItemsTableViewCellProtocol: AnyObject {
    func didItemSelected(index: Int)
}
class SwapItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var myItemImageView: UIImageView!
    @IBOutlet weak var myItemTitleLabel: UILabel!
    @IBOutlet weak var myItemPriceLabel: UILabel!
    @IBOutlet weak var swapItemImageView: UIImageView!
    @IBOutlet weak var swapItemTitleLabel: UILabel!
    @IBOutlet weak var swapItemPriceLabel: UILabel!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var swappedUserInfoView: UIView!
    @IBOutlet weak var swappedUserNamelabel: UILabel!
    @IBOutlet weak var swappedUserEmailLabel: UILabel!
    @IBOutlet weak var swappedUserPhonelabel: UILabel!
    var index: Int = 0
    weak var delegate: SwapItemsTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func swapButtonTapped() {
        delegate?.didItemSelected(index: index)
    }

}
