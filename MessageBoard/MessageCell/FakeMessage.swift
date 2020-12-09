//
//  FakeMessage.swift
//  MessageBoard
//
//  Created by ZouYa on 2020/11/25.
//

import UIKit

class FakeMessage:UICollectionViewCell{
    
    static let ID = "FakeMessageCell"
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(message:FakeMessageData){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        var attributeString = NSMutableAttributedString()
        
        if message.newID == nil {
            let attributes:[NSAttributedString.Key:Any] = [.font: UIFont.systemFont(ofSize: 24),.foregroundColor: UIColor.init(red: 41.0/255.0, green: 137.0/255.0, blue: 187.0/255.0, alpha: 1),.paragraphStyle:paragraphStyle]
            attributeString = NSMutableAttributedString(string: message.content, attributes: attributes)
        }else{
            let firstAttributes:[NSAttributedString.Key:Any] = [.foregroundColor: UIColor.init(red: 41.0/255.0, green: 137.0/255.0, blue: 187.0/255.0, alpha: 1),.font:UIFont.boldSystemFont(ofSize: 24),.paragraphStyle:paragraphStyle]
            let tailAttributes:[NSAttributedString.Key:Any] = [.foregroundColor:UIColor.gray,.font:UIFont.systemFont(ofSize: 24),.paragraphStyle:paragraphStyle]
            attributeString = NSMutableAttributedString(string: message.newID!, attributes: firstAttributes)
            let tailAttributeString = NSAttributedString(string: message.content, attributes: tailAttributes)
            attributeString.append(tailAttributeString)
        }
        
        
        addSubview(label)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = screen_width - 10
        label.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.7960784314, blue: 0.8117647059, alpha: 1)
        label.attributedText = attributeString
        label.frame = CGRect(x: 5, y: 5, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
    }
    
    func returnSize()->CGSize{
        return CGSize(width: screen_width, height: label.intrinsicContentSize.height)
    }
}
