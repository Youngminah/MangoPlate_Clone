//
//  WriteReviewViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/23.
//

import UIKit



class WriteReviewViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var greatButton: UIButton!
    @IBOutlet weak var sosoButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var inputNoticeViewBottom: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var inputNoticeView: UIView!
    @IBOutlet weak var inputNoticeButton: UIButton!
    
    var imageURLString: [String] = []
    let writeReviewViewModel = WriteReviewInputViewModel()
    var reviewScore: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("이미지는 뭐가 들어왔나?\(imageURLString)")
        updateCharacterCount()
        updateUI()
        setNotificationKeyboard()
    }
    
    @IBAction func gradeButtonsTab(_ sender: UIButton) {
        sender.isSelected = true
        if sender.tag == 0 {
            sosoButton.isSelected = false
            badButton.isSelected = false
            reviewScore = 1
        }
        else if sender.tag == 1{
            greatButton.isSelected = false
            badButton.isSelected = false
            reviewScore = 0
        }
        else{
            greatButton.isSelected = false
            sosoButton.isSelected = false
            reviewScore = -1
        }
    }
    
    @IBAction func reviewPostButtonTab(_ sender: UIButton) {
        self.showIndicator()
        for imageString in imageURLString{
            self.writeReviewViewModel.appendReviewImages(imageURLString: imageString)
            print("사진선택한 갯수만큼 출력될것이닷")
        }
        self.writeReviewViewModel.setInput( restaurantID: 1, reviewScore: reviewScore, reviewContents: textView.text)
        print("사진 선택 출력 완료후 이 문장이 실행되어야함")
        self.writeReviewViewModel.postImageListAPI()
        self.writeReviewViewModel.didFinishFetch = {
            print("이미지 보내기 완료!")
            //화면 2개 dismiss
            self.dismissIndicator()
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        DispatchQueue.main.async {
            self.updateCharacterCount()
        }
    }
    
    func updateUI(){
        self.textView.delegate = self
        self.inputNoticeViewBottom.constant = inputNoticeView.viewHeight
    }
    
    func updateCharacterCount() {
        let reviewsCount = self.textView.text.count
        self.inputNoticeButton.setTitle("입력완료 (\((0) + reviewsCount)/10000)", for: .normal)
    }
    
    //텍스트뷰 글자수 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count > 0 {
            self.inputNoticeButton.backgroundColor = #colorLiteral(red: 0.992348969, green: 0.4946574569, blue: 0.004839691333, alpha: 1)
        }else{
            self.inputNoticeButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        return newText.count <= 10000
    }
}

//MARK: Cell에서 가고싶다 클릭시, 로그인이 안되어있으면 로그인하는 화면 띄우는 프로토콜
extension WriteReviewViewController: SendImageDataDelegate{
    func sendData(data: String) {
        self.imageURLString.append(data)
        print(data)
    }
}


// MARK: Keyboard관련 UI 설정.
extension WriteReviewViewController{
    
    func setNotificationKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // [x] TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            print(inputNoticeViewBottom.constant)
            let adjustmentHeight = keyboardFrame.height
            self.inputNoticeViewBottom.constant = -adjustmentHeight
        } else {
            self.inputNoticeViewBottom.constant = inputNoticeView.viewHeight
        }
        print("---> Keyboard End Frame: \(keyboardFrame)")
    }
    
    //화면 아무곳 클릭하면 키보드 내려가게 하기.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
    }
}
