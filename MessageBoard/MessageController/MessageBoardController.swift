//
//  ViewController.swift
//  MessageBoard
//
//  Created by ZouYa on 2020/11/25.
//

import UIKit
import SnapKit
import AVFoundation

let screen_width = UIScreen.main.bounds.width
let screen_height = UIScreen.main.bounds.height

class MessageBoardController: UIViewController {
    
    var MessageBoard:UICollectionView!
    let layout = UICollectionViewFlowLayout()
    
    var imagePicker = UIImagePickerController()
    var imageBtn = UIButton()
    
    var inputTextView = UITextView()
    
    var audioBtn = UIButton()
    var audioRecorder : AVAudioRecorder!
    var recordingSession : AVAudioSession!
    
    var numberOfRecordAudio:Int = 0
    var isRecording: Bool = false
    
    var newMessageIndicator = UIButton()
    var numberOfNewMessage:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = #colorLiteral(red: 0.5764705882, green: 0.7098039216, blue: 0.8117647059, alpha: 1)
        
        setupCollectionView()
        setupBtn()
        setupInputTextView()
        
        imagePicker.delegate = self
        inputTextView.delegate = self
        
        loadData(filename: "test")
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageBoardController.updateTextView(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageBoardController.updateTextView(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
        tapGestureReconizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureReconizer)
        
    }
    
    
    func setupCollectionView(){
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: screen_width, height: 100)
        
        MessageBoard = UICollectionView(frame: CGRect(x: 0, y: 35, width: screen_width, height: screen_height - 105), collectionViewLayout: layout)
        self.view.addSubview(MessageBoard)
        MessageBoard.backgroundColor = #colorLiteral(red: 0.6549019608, green: 0.6588235294, blue: 0.7411764706, alpha: 1)
        MessageBoard.contentSize = CGSize(width: screen_width, height: screen_height*5)
        
        MessageBoard.delegate = self
        MessageBoard.dataSource = self
        MessageBoard.register(TrueMessage.self, forCellWithReuseIdentifier: TrueMessage.ID)
        MessageBoard.register(FakeMessage.self, forCellWithReuseIdentifier: FakeMessage.ID)
        
        MessageBoard.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
    }
    
    func setupBtn(){
        self.view.addSubview(imageBtn)
        imageBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(MessageBoard.snp.bottom).offset(5)
            make.width.height.equalTo(40)
        }
        imageBtn.setBackgroundImage(UIImage(named: "picture.png"), for: .normal)
        imageBtn.addTarget(self, action: #selector(imageBtnClick(_:)), for: .touchUpInside)
        
        self.view.addSubview(audioBtn)
        audioBtn.snp.makeConstraints { (make) in
            make.left.equalTo(imageBtn.snp.right).offset(10)
            make.top.equalTo(MessageBoard.snp.bottom).offset(5)
            make.width.height.equalTo(40)
        }
        audioBtn.setBackgroundImage(UIImage(named: "audio.png"), for: .normal)
        audioBtn.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
    }
    
    func setupInputTextView(){
        self.view.addSubview(inputTextView)
        
        inputTextView.snp.makeConstraints { (make) in
            make.top.equalTo(MessageBoard.snp.bottom).offset(5)
            make.left.equalTo(audioBtn.snp.right).offset(5)
            make.height.equalTo(40)
            make.width.equalTo(screen_width - 120)
        }
        
        inputTextView.layer.masksToBounds = true
        inputTextView.layer.cornerRadius = 10
        
        inputTextView.font = .systemFont(ofSize: 20)
    }
    
    func setupNewMessageIndicator(){
        self.view.addSubview(newMessageIndicator)
        
        newMessageIndicator.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalTo(audioBtn.snp.top)
            make.height.equalTo(40)
            make.width.equalTo(screen_width)
        }
        newMessageIndicator.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.7019607843, blue: 0.8, alpha: 1)
        newMessageIndicator.addTarget(self, action: #selector(messageIndicatorClicked), for: .touchUpInside)
    }
    
    @objc func messageIndicatorClicked(){
        
        MessageBoard.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        numberOfNewMessage = 0
        newMessageIndicator.removeFromSuperview()
    }
    
    func detectContentPoint(){
        if MessageBoard.contentOffset.y > 33.5 {
            if numberOfNewMessage == 0 {
                setupNewMessageIndicator()
            }
            numberOfNewMessage += 1
            newMessageIndicator.setTitle("你有\(numberOfNewMessage)条新消息", for: .normal)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if MessageBoard.contentOffset.y < 33.5 {
            MessageBoard.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            numberOfNewMessage = 0
            newMessageIndicator.removeFromSuperview()
        }
    }
    
}

//MARK:local file extension
extension MessageBoardController{
    
    func loadData(filename:String){
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let jsonResult = json as? Dictionary<String, Any>,let message = jsonResult["message"] as? [Any]{
                    
//                    let indexPath = IndexPath(item: 0, section: 0)
                    for index in 0..<message.count {
                    let newMessage = TrueMessageData.init(json: message[index] as! [String : Any])
                    dataArr.insert(newMessage as Any, at: 0)
//                        MessageBoard.insertItems(at: [indexPath])
                    }
//                    MessageBoard.reloadItems(at: MessageBoard.indexPathsForVisibleItems)
                }
              } catch {
                   print("error")
              }
        }
    }
    
}

//MARK:get image from Internet extension
//extension MessageBoardController{
//
//    func getImageFromInternet() {
//
//        let urlStr = "https://api.ixiaowai.cn/mcapi/mcapi.php"
//        let request = URLRequest(url: URL(string: urlStr)!)
//        let session = URLSession(configuration: .default)
//        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
//            if error == nil, let data = data {
//                DispatchQueue.main.async { [self] in
//                    let image = UIImage(data: data)
//                    dataArr.insert(TrueMessageData(head: "Ya",image: image), at: 0)
//                    let indexPath = IndexPath(item: 0, section: 0)
//                    MessageBoard.insertItems(at: [indexPath])
//                    MessageBoard.reloadItems(at: MessageBoard.indexPathsForVisibleItems)
//                }
//            }
//        }
//        dataTask.resume()
//    }
//
//}

//MARK:imagePicker extension
extension MessageBoardController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func openCamera(){
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "警告", message: "未打开摄像头", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func openLabrary(){
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "警告", message: "没有权限访问照片", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            let newMessage = TrueMessageData(head: "Ya", image: pickedImage)
            dataArr.insert(newMessage, at: 0)
            
            let indexPath = IndexPath(item: 0, section: 0)
            MessageBoard.insertItems(at: [indexPath])
            MessageBoard.reloadItems(at: MessageBoard.indexPathsForVisibleItems)
            
            detectContentPoint()

        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imageBtnClick(_ sender:UIButton){
        let alert = UIAlertController(title: "选择图片", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "拍照", style: .default,handler: {
            _ in self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "从照片中选择", style: .default,handler: {
            _ in self.openLabrary()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK:TextView extension
extension MessageBoardController: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                
                let newMessage = TrueMessageData(head: "Ya", tail: textView.text )
                dataArr.insert(newMessage, at: 0)
                let indexPath = IndexPath(item: 0, section: 0)
                MessageBoard.insertItems(at: [indexPath])
                MessageBoard.reloadItems(at: MessageBoard.indexPathsForVisibleItems)
                
                detectContentPoint()
                
                inputTextView.text = nil
                inputTextView.resignFirstResponder()
                return false
            }
            return true
    }
    
    
    @objc func updateTextView(notification: Notification)
        {
            if let userInfo = notification.userInfo
            {
                let keyboardFrameScreenCoordinates = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                
                let keyboardFrame = self.view.convert(keyboardFrameScreenCoordinates, to: view.window)
                
                if notification.name == UIResponder.keyboardWillHideNotification{
                    view.frame.origin.y = 0
                }
                else{
                    view.frame.origin.y = -keyboardFrame.height
                }
            }
    }
    
    @objc func tap(sender: UITapGestureRecognizer) {
        inputTextView.resignFirstResponder()
    }

}
//MARK:AVAudioRecorder extension
extension MessageBoardController: AVAudioRecorderDelegate{
    
    func getPermission(){
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do{
            try recordingSession.setCategory(.playAndRecord,mode:.default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission(){
                [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        //more
                        
                    }else{
                        let alert = UIAlertController(title: "警告", message: "没有录音权限", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
        }catch{
            let alert = UIAlertController(title: "警告", message: "没有录音权限", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func startRecording()->URL{
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording\(numberOfRecordAudio).mp4")
        numberOfRecordAudio += 1
        
        let settings = [
            AVFormatIDKey:Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey:12000,
            AVNumberOfChannelsKey:1,
            AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
        ]
        
        do{
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        }catch{
            finishingRecording()
        }
        
        return audioFilename
    }
    
    func getDocumentsDirectory()-> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishingRecording(){
        if audioRecorder.isRecording{
        audioRecorder.stop()
        }
    }
    
    @objc func recordTapped(){
        
        if isRecording == true {
            inputTextView.text = nil
            
            finishingRecording()
            isRecording = false
            let indexPath = IndexPath(item: 0, section: 0)
            MessageBoard.insertItems(at: [indexPath])
            MessageBoard.reloadItems(at: MessageBoard.indexPathsForVisibleItems)
            
            detectContentPoint()
            
        }else{
            inputTextView.text = "正在录音..."
            
            if audioRecorder == nil{
                let path = startRecording()
                let newMessage = TrueMessageData(head: "Ya", path: path)
                dataArr.insert(newMessage, at: 0)
            }
            isRecording = true
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if !flag {
            finishingRecording()
        }
    }
    
}

//MARK:collectionView extension
extension MessageBoardController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if dataArr[indexPath.row] is TrueMessageData {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrueMessage.ID, for: indexPath) as! TrueMessage
            cell.setupUI(message: dataArr[indexPath.row] as! TrueMessageData)
            cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FakeMessage.ID, for: indexPath) as! FakeMessage
            cell.setupUI(message: dataArr[indexPath.row] as! FakeMessageData)
            cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            return cell
        }
    }
    
}

//MARK:flowLayout extension
extension MessageBoardController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if dataArr[indexPath.row] is TrueMessageData {
            let cell = TrueMessage()
            cell.setupUI(message: dataArr[indexPath.row] as! TrueMessageData)
            return cell.returnSize()
        }else{
            let cell = FakeMessage()
            cell.setupUI(message: dataArr[indexPath.row] as! FakeMessageData)
            return cell.returnSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    
}

