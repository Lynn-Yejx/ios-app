//
//  yyTableViewCell.swift
//  gift
//
//  Created by 敬轩 on 2019/5/13.
//  Copyright © 2019 敬轩. All rights reserved.
//

import UIKit

class yyTableViewCell: UITableViewCell {

    @IBOutlet weak var yyImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.clear
        yyImageView.clipsToBounds = true
        yyImageView.backgroundColor = UIColor.clear
        yyImageView.contentMode = .scaleAspectFill
        yyImageView.layer.cornerRadius = 15
//        contentView.backgroundColor = UIColor.red
        yyImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
        }
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
