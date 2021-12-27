//
//  SearchBookCell.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import UIKit

public final class SearchBookCell: UITableViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var isbn13Label: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        bookImageView.image = nil
    }
}
