//
//  ViewController.swift
//  Publisher
//
//  Created by PoChieh Chuang on 2021/10/12.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // add-button setup
    private var floatingButton: UIButton?
    private let floatingButtonImageName = "Icons_24px_Add01"
    private static let buttonHeight: CGFloat = 75.0
    private static let buttonWidth: CGFloat = 75.0
    private let roundValue = ViewController.buttonHeight/2
    private let trailingValue: CGFloat = 15.0
    private let leadingValue: CGFloat = 15.0
    private let shadowRadius: CGFloat = 2.0
    private let shadowOpacity: Float = 0.5
    private let shadowOffset = CGSize(width: 0.0, height: 5.0)
    private let scaleKeyPath = "scale"
    private let animationKeyPath = "transform.scale"
    private let animationDuration: CFTimeInterval = 0.4
    private let animateFromValue: CGFloat = 1.00
    private let animateToValue: CGFloat = 1.05
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "HomePageCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "HomePageCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchData()
        tableView.reloadData()
        
    }

    let db = Firestore.firestore()
    
    var articleTitles: [String] = []
    var articleCategories: [String] = []
    var articleContents: [String] = []
    
    func fetchData() {
        
        print("start fetch")
        
        db.collection("articles").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Fetching data failed...:\(err)")
            } else {
                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
                    guard let articleTitle = document.get("title") as? String
                    else {
                        print("getting title failed...")
                        return
                    }
                    guard let articleContent = document.get("content") as? String
                    else {
                        print("getting content failed...")
                        return
                    }
                    guard let articleCategory = document.get("category") as? String
                    else {
                        print("getting category failed...")
                        return
                    }
                    
                    self.articleTitles.append(articleTitle)
                    self.articleContents.append(articleContent)
                    self.articleCategories.append(articleCategory)
                    
                    self.tableView.reloadData()
                    
                }
            }
            
        }
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createFloatingButton()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        guard floatingButton?.superview != nil else {  return }
        DispatchQueue.main.async {
            self.floatingButton?.removeFromSuperview()
            self.floatingButton = nil
        }
        super.viewWillDisappear(animated)
    }

    private func createFloatingButton() {
        floatingButton = UIButton(type: .custom)
        floatingButton?.translatesAutoresizingMaskIntoConstraints = false
        floatingButton?.backgroundColor = .white
        floatingButton?.setImage(UIImage(named: floatingButtonImageName), for: .normal)
        floatingButton?.addTarget(self, action: #selector(doThisWhenButtonIsTapped(_:)), for: .touchUpInside)
        constrainFloatingButtonToWindow()
        makeFloatingButtonRound()
        addShadowToFloatingButton()
        addScaleAnimationToFloatingButton()
    }

    // TODO: Add some logic for when the button is tapped.
    @IBAction private func doThisWhenButtonIsTapped(_ sender: Any) {
        
        print("Button Tapped")
        if let controller = storyboard?.instantiateViewController(identifier: "Publish") as? PublishArticleViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    private func constrainFloatingButtonToWindow() {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.shared.keyWindow,
                let floatingButton = self.floatingButton else { return }
            keyWindow.addSubview(floatingButton)
            keyWindow.trailingAnchor.constraint(equalTo: floatingButton.trailingAnchor,
                                                constant: self.trailingValue).isActive = true
            keyWindow.bottomAnchor.constraint(equalTo: floatingButton.bottomAnchor,
                                              constant: self.leadingValue).isActive = true
            floatingButton.widthAnchor.constraint(equalToConstant:
                ViewController.buttonWidth).isActive = true
            floatingButton.heightAnchor.constraint(equalToConstant:
                ViewController.buttonHeight).isActive = true
        }
    }

    private func makeFloatingButtonRound() {
        floatingButton?.layer.cornerRadius = roundValue
    }

    private func addShadowToFloatingButton() {
        floatingButton?.layer.shadowColor = UIColor.black.cgColor
        floatingButton?.layer.shadowOffset = shadowOffset
        floatingButton?.layer.masksToBounds = false
        floatingButton?.layer.shadowRadius = shadowRadius
        floatingButton?.layer.shadowOpacity = shadowOpacity
    }

    private func addScaleAnimationToFloatingButton() {
        // Add a pulsing animation to draw attention to button:
        DispatchQueue.main.async {
            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: self.animationKeyPath)
            scaleAnimation.duration = self.animationDuration
            scaleAnimation.repeatCount = .greatestFiniteMagnitude
            scaleAnimation.autoreverses = true
            scaleAnimation.fromValue = self.animateFromValue
            scaleAnimation.toValue = self.animateToValue
            self.floatingButton?.layer.add(scaleAnimation, forKey: self.scaleKeyPath)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articleTitles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomePageCell", for: indexPath) as? HomePageCell
        else {
            fatalError()
        }
        
        cell.titleLbl.text = articleTitles[indexPath.row]
        cell.categoryLbl.text = articleCategories[indexPath.row]
        cell.contentLbl.text = articleContents[indexPath.row]
        
        return cell
    }
    
    
}
