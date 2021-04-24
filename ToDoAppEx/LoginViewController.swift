//
//  LoginViewController.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/04/11.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func login(_ sender: Any) {
        
        let urlString = "http://tk2-235-27465.vs.sakura.ne.jp/login"
        
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params:[String:Any] = [
            "email": self.email.text,
//            "limit":4
        ]//[:
        //            "author": textFieldAuthor.text!,
        //            "name": textFieldName.text!
        //        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in

                print("############")
                                print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as Any)
                
                do {
                    // dataをJSONパースし、変数"getJson"に格納
                    //getJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    
//                    self.downloadJsonLength = json["count"] as! Int
                    //                    let jsonDictionary = json as! NSDictionary
                    //                    print(self.downloadJsonLength)
                    
//                    self.donwloadJson.append(json2)
                    //                    print(self.donwloadJson.count)
                    
                    
                    
                    
                    
                    
                        DispatchQueue.main.async {
//                            for y in 0..<json2.count {
//                                let dictionary = json2[y] as! NSDictionary

                                //                            for ranking in rankingArray {
                                
//                            for i in 0..<json.count {
                                let json2 = json as! NSDictionary

                                let login : Bool = json2["login"] as! Bool
                                
                                if login {
                                    
                                    
                                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
                                    self.present(secondViewController, animated: true, completion: nil)

                                    
                                    
                                } else {
                                    self.email.text = "error!!"
                                }
//
                                
//                                let date : String = json2["date"] as! String
////                                let nameNode = SKLabelNode(text: text.prefix(10).description )

//                                let nameNode = SKLabelNode(text: text)
//                                let timeNode = SKLabelNode(text: (json2["time"] as? Int)?.description )
//                                let pointNode = SKLabelNode(text: (json2["point"] as? Int)?.description )
//                                let chainNode = SKLabelNode(text: (json2["chain"] as? Int)?.description )
//                                let worldRanking = WorldRanking()
//                                worldRanking.name = text
//                                worldRanking.date = date.prefix(10).description
//                                worldRanking.time = json2["time"] as! Int
//                                worldRanking.point = json2["point"] as! Int
//                                worldRanking.chain = json2["chain"] as! Int
//
//                                self.worldRankingArray.append(worldRanking)
//                            }

//                            let array1 = self.worldRankingArray.sorted { $0.time < $1.time }
//                            let array2 = array1.sorted { $0.point > $1.point }
//                            let array3 = array2.sorted { $0.chain > $1.chain }
//
//                            var i = 0
//                            for worldRanking in array3 {
//                                let nameNode = SKLabelNode(text: worldRanking.name)
//                                let timeNode = SKLabelNode(text: worldRanking.time.description )
//                                let pointNode = SKLabelNode(text: worldRanking.point.description )
//                                let chainNode = SKLabelNode(text: worldRanking.chain.description )
//
//                                nameNode.setScale(0.7)
//                                timeNode.setScale(0.7)
//                                pointNode.setScale(0.7)
//                                chainNode.setScale(0.7)
//                                nameNode.position.x = 120
//                                timeNode.position.x = 120
//                                pointNode.position.x = 190
//                                chainNode.position.x = 270
//
//                                nameNode.position.y = 450 - CGFloat(i) * 80
//                                timeNode.position.y = 400 - CGFloat(i) * 80
//                                pointNode.position.y = 400 - CGFloat(i) * 80
//                                chainNode.position.y = 400 - CGFloat(i) * 80
//
//                                self.addChild(nameNode)
//                                self.addChild(timeNode)
//                                self.addChild(pointNode)
//                                self.addChild(chainNode)
//                                self.nameLabelArray.append(nameNode)
//                                self.timeLabelArray.append(timeNode)
//                                self.pointLabelArray.append(pointNode)
//                                self.chainLabelArray.append(chainNode)
//                                i += 1
//                                if i >= 5 {
//                                    break
//                                }
//                            }
                        }
                        
                    
                    
                    
                } catch {
                    print ("json error")
                    return
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
