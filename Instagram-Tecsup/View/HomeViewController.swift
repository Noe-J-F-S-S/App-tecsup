//
//  HomeViewController.swift
//  Instagram-Tecsup
//
//  Created by Mac41 on 18/11/22.
//

import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController{
    

    @IBOutlet weak var tableView: UITableView!
    
    var db = Firestore.firestore()
    var posts: [Post] = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        getPost()
    }
    
    func setUpTable(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getPost() {
        db.collection("post").getDocuments {querySnapshot, error in
            for document in querySnapshot!.documents {
                let data = document.data()
                let newPost = Post(
                    image: data["image"] as? String ?? "",
                    title: data["title"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    userId: data["userId"] as? String ?? ""
                )
                self.posts.append(newPost)
                print("newPost \(newPost)")
            }
            self.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        cell.titlePost.text = posts[indexPath.row].title
        cell.descriptionPost.text = posts[indexPath.row].description
        
        let imageURL = URL(string: posts[indexPath.row].image)
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data {
            cell.imagePost.image = UIImage(data: imageData)
            cell.imagePost.contentMode = .scaleAspectFill
        }
        
        return cell
    }
}
