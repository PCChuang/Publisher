//
//  PublishArticleViewController.swift
//  Publisher
//
//  Created by PoChieh Chuang on 2021/10/12.
//

import UIKit
import Firebase

class PublishArticleViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    
    @IBAction func postBtnTapped(_ sender: UIButton) {
        print("Post Button is tapped")
        titleText = titleTextField.text ?? ""
        contentText = contentTextField.text ?? ""
        categoryText = categoryTextField.text ?? ""
//
//        let timestamp = NSDate().timeIntervalSince1970
//        let myTimeInterval = TimeInterval(timestamp)
//        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        addData()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomView.layer.borderWidth = 2
        bottomView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    var titleText: String = ""
    var categoryText: String = ""
    var contentText: String = ""
    
    func addData() {
        let articles = Firestore.firestore().collection("articles")
        let document = articles.document()
        let data: [String: Any] = [
            "author": [
                "email": "wayne@school.appworks.tw",
                "id": "waynechen323",
                "name": "AKA小安老師"
            ],
            "title": titleText,
            "content": contentText,
            "createdTime": NSDate().timeIntervalSince1970,
            "id": document.documentID,
            "category": "Beauty"
        ]
        document.setData(data)
    }

}
