//
//  MessageData.swift
//  MessageBoard
//
//  Created by ZouYa on 2020/11/25.
//

import UIKit

struct TrueMessageData {
    
    var head: String
    var tail: String?
    
    var image: UIImage?
    var path: URL?
    
    init?(head:String,tail:String? = nil,image:UIImage? = nil,path:URL? = nil) {
        self.head = head
        if tail != nil {
            self.tail = tail
        }
        if image != nil {
            self.image = image
        }
        if path != nil {
            self.path = path
        }
    }
    
    init?(json:[String:Any]) {
        guard let head = json["head"] as? String else {
            return nil
        }
        self.head = head
        if let tail = json["tail"] as? String {
            self.tail = tail
        }
        if let image = json["image"] as? UIImage {
            self.image = image
        }
        if let path = json["path"] as? URL {
            self.path = path
        }
    }
}



struct FakeMessageData {
    
    var content: String
    
    var newID: String?
    
    init?(content:String,newID:String? = nil) {
        self.content = content
        if newID != nil {
            self.newID = newID
        }
    }
    
    init?(json:[String:Any]) {
        
        guard let content = json["content"] as? String else {
            return nil
        }
        self.content = content
        if let newID = json["newID"] as? String {
            self.newID = newID
        }
        
    }
    
}

//数据数组中，新消息在前，加入一条新的消息应该放在最前方
var dataArr = [TrueMessageData(head: "Joe", tail: "You were my town💦"),TrueMessageData(head: "Rachel", tail: "Now I'm exile seeing you out"),TrueMessageData(head: "Monica", tail: "Sometimes a story has no end"),FakeMessageData(content: "购买直播推荐商品时，请点击屏幕下方购物袋按钮进行交易，并确认购买链接描述与实际商品一致，避免私自转账，谨防上当受骗"),TrueMessageData(head: "Ross", tail: "And I know it's long gone and there was nothing else I could do.And I forget about you long enough to forget why I needed to"),FakeMessageData(content: "来了", newID: "Peter"),TrueMessageData(head: "Taytay", tail: "All too well"),TrueMessageData(head: "Cathy", tail: "Cute", image: UIImage(named: "exampleImage.jpeg"))] as [Any]
