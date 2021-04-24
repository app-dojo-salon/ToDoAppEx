//
//  SignupViewController.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/04/11.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func createAccount(_ sender: Any) {
        let urlString = "http://tk2-235-27465.vs.sakura.ne.jp/insert_account"
        
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params:[String:Any] = [
            "accountname": self.email.text,
//            "chain": array3[0].chain,
//            "point": array3[0].point,
//            "time": array3[0].time//,
         //   "date": rank.date
        ]
//        if monthFlag {
//            params = [
//                "name": self.rankingName[0].name,
//                "chain": montharray3[0].chain,
//                "point": montharray3[0].point,
//                "time": montharray3[0].time//,
//            ]
//        }
//
//        if dayFlag {
//            params = [
//                "name": self.rankingName[0].name,
//                "chain": dayarray3[0].chain,
//                "point": dayarray3[0].point,
//                "time": dayarray3[0].time//,
//            ]
//        }
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)

            let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
                
                
                
                //                        let resultData = String(data: data!, encoding: .utf8)!
                //                        print("result:\(resultData)")
                //                        print("response:\(response)")
            })
            task.resume()
        }catch{
            print("Error:\(error)")
            return
        }

        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(secondViewController, animated: true, completion: nil)

    }
}
