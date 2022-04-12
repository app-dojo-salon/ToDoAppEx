//
//  ShareViewController.swift
//  ToDoAppEx
//
//  Created by izumiyoshiki on 2021/03/07.
//

import UIKit
import RealmSwift

class ShareViewController: UIViewController {

    @IBOutlet weak var searchButton: UIBarButtonItem!

    @IBOutlet weak var tableView: UITableView!

    private var shareAccounts: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.tintColor = UIColor.clear
        getShareAccounts(data: nil)
        tableView.delegate = self
        tableView.dataSource = self
    }

    func getShareAccounts(data: Data?) {
        let serverRequest: ServerRequest = ServerRequest()
        serverRequest.sendServerRequest(
            urlString: "http://tk2-235-27465.vs.sakura.ne.jp/get_accounts",
            params: [:],
            completion: self.setShareAccounts(data:))
    }
    
    func setShareAccounts(data: Data?) {
        shareAccounts = []
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            DispatchQueue.main.async {
                let docs : NSArray = json as! NSArray
                print(docs)
                for doc in docs {
                    guard let _doc = doc as? NSDictionary else { return }
                    if _doc["publicprivate"] != nil,
                       _doc["publicprivate"] as! Bool {
                        self.shareAccounts.append((doc as! NSDictionary)["accountname"] as! String)
                    }
                }                
            }
        } catch {
            print ("json error")
            return
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    @IBAction func tappedShareButton(_ sender: Any) {

        let nextVC = storyboard?.instantiateViewController(withIdentifier: "AskPasswordSettingViewController") as! AskPasswordSettingViewController
        present(nextVC, animated: true, completion: nil)


    }
    
}

extension ShareViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shareAccounts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shareAccount", for: indexPath) as! ShareAccountCell
        cell.configure(title: shareAccounts[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "ShareTodoItemListViewController") as! ShareTodoItemListViewController
        nextVC.configure(shareAccount: shareAccounts[indexPath.row])
        self.present(nextVC, animated: true, completion: nil)
    }
}
