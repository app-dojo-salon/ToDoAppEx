//
//  SignupViewController.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/04/11.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction private func createAccount(_ sender: Any) {
        
        if password.text != "" && password.text == confirmPassword.text {
        
            let urlString = "http://tk2-235-27465.vs.sakura.ne.jp/insert_account"
            
            let request = NSMutableURLRequest(url: URL(string: urlString)!)
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let params:[String:Any] = [
                "accountname": self.email.text,
                "password": self.password.text
            ]
            
            var errorFlag = false
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)

                let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
                    if error != nil {
                        DispatchQueue.main.sync {
                            errorFlag = true
                            self.email.text = "server error!!"
                            print(error.debugDescription)
                        }
                        return
                    }
                })
                task.resume()
            }catch{
                email.text = "server error!!"
                print("Error:\(error)")
                return
            }

            if errorFlag == false {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                secondViewController.modalPresentationStyle = .fullScreen
                self.present(secondViewController, animated: true, completion: nil)
            }
            return
        } else {
            email.text = "password error!!"
        }
    }
}
