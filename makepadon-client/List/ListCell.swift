//
//  ListCell.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/04/15.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setup(status: Status) -> Void {
        iconImageView.kf.setImage(with: URL(string: status.account.avatar)!)
        titleLabel.text = "@\(status.account.username) - \(status.account.displayName)"
        
        // HTML データをレンダリングする。
        guard let data = status.content.data(using: .utf8, allowLossyConversion: true) else { return }
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue,
            ]
        guard let attrText = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else { return }
        descriptionLabel.attributedText = attrText
    }
}
