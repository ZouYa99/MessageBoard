//
//  TrueMessage.swift
//  MessageBoard
//
//  Created by ZouYa on 2020/11/25.
//

import UIKit
import AVFoundation

class TrueMessage:UICollectionViewCell{
    
    static let ID = "TrueMessageCell"
    
    var label = UILabel()
    
    var player = AVAudioPlayer()
    var audioToPlay = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(message:TrueMessageData){
        
        let headAttributes:[NSAttributedString.Key:Any] = [.foregroundColor: UIColor.init(red: 39.0/255.0, green: 117.0/255.0, blue: 182.0/255.0, alpha: 1),.font: UIFont.systemFont(ofSize: 28)]
        let attributedString = NSMutableAttributedString(string: message.head + " : ", attributes: headAttributes)
        
        if message.tail != nil {
            let tailAttributes:[NSAttributedString.Key:Any] = [.foregroundColor: UIColor.black,.font: UIFont.systemFont(ofSize: 25)]
            let tailString = NSAttributedString(string: (message.tail)!, attributes: tailAttributes)
            attributedString.append(tailString)
        }
        
        if message.image != nil {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = message.image
            let imageScale = message.image!.size.height / message.image!.size.width
            imageAttachment.bounds = CGRect(x: 0, y: 0, width: screen_width, height: imageScale * screen_width)
            let imageString = NSAttributedString(attachment: imageAttachment)
            attributedString.append(imageString)
        }
        
        if message.path != nil{
            
            player = try! AVAudioPlayer(contentsOf: message.path!)
            player.numberOfLoops = 1
            player.delegate = self
            
            let duration = Int(player.duration)
            let minutes = duration/60
            let seconds = duration - minutes * 60
            let string = NSString(format: "%02d:%02d      ", minutes,seconds) as String
            
            let tailAttributes:[NSAttributedString.Key:Any] = [.foregroundColor: UIColor.black,.font: UIFont.systemFont(ofSize: 25)]
            let tailString = NSAttributedString(string: string, attributes: tailAttributes)
            attributedString.append(tailString)
            
            setupAudioBtn()
            
        }
        
        addSubview(label)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.preferredMaxLayoutWidth = screen_width - 10
        label.attributedText = attributedString
        label.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.7960784314, blue: 0.8117647059, alpha: 1)
        label.frame = CGRect(x: 5, y: 5, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
    }
    
    func setupAudioBtn(){
        label.isUserInteractionEnabled = true
        label.addSubview(audioToPlay)
        audioToPlay.setImage(UIImage(named: "start.png"), for: .normal)
        audioToPlay.snp.makeConstraints { (make) in
            make.width.height.equalTo(26)
            make.right.equalTo(label.snp.right).offset(-3)
            make.top.equalTo(label.snp.top).offset(3)
        }
        audioToPlay.addTarget(self, action: #selector(controlAudio), for: .touchUpInside)
    }
    
    @objc func controlAudio(){
        
        if player.isPlaying {
            player.pause()
            audioToPlay.setImage(UIImage(named: "start.png"), for: .normal)
        }else{
            player.play()
            audioToPlay.setImage(UIImage(named: "stop.png"), for: .normal)
        }
        
    }
    
    func returnSize()->CGSize{
        return CGSize(width: screen_width, height: label.intrinsicContentSize.height)
    }
    
}

extension TrueMessage: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            audioToPlay.setImage(UIImage(named: "start.png"), for: .normal)
        }
    }
}
