//
//  LoginViewController.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/04/11.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    
    
    @IBAction private func login(_ sender: Any) {
        
        let urlString = "http://tk2-235-27465.vs.sakura.ne.jp/login"
        
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params:[String:Any] = [
            "email": self.email.text
        ]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
                if error != nil {
                    DispatchQueue.main.sync {
                        self.email.text = "server error!!"
                        print(error.debugDescription)
                    }
                    return
                } else {
                    do {
                        // dataをJSONパースし、変数"getJson"に格納
                        let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                            DispatchQueue.main.async {
                                    let login : Bool = (json as! NSDictionary)["login"] as! Bool
                                    if login {
                                        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                                        secondViewController.modalPresentationStyle = .fullScreen
                                        self.present(secondViewController, animated: false, completion: nil)
                                    } else {
                                        self.email.text = "error!!"
                                    }
                            }
                    } catch {
                        print ("json error")
                        return
                    }
                }
            })
            task.resume()
        }catch{
            print("Error:\(error)")
            return
        }
        return
    }
}
