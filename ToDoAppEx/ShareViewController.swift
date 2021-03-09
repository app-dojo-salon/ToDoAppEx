//
//  ShareViewController.swift
//  ToDoAppEx
//
//  Created by izumiyoshiki on 2021/03/07.
//

import UIKit

class ShareViewController: UIViewController, UINavigationBarDelegate, UITabBarDelegate {

    @IBOutlet weak var navigationbar: UINavigationBar!
    @IBOutlet weak var tabbar: UITabBar!
    @IBAction func shareButton(_ sender: Any) {
    }
    @IBAction func searchButton(_ sender: Any) {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        searchVC.modalPresentationStyle = .fullScreen
        self.present(searchVC, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationbar.delegate = self
        tabbar.delegate = self
    }


    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 0) {
            let homeVC = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true, completion: nil)
        } else if(item.tag == 1) {
            let editVC = storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
            editVC.modalPresentationStyle = .fullScreen
            self.present(editVC, animated: true, completion: nil)
        } else if(item.tag == 2) {
            let settingVC = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
            settingVC.modalPresentationStyle = .fullScreen
            self.present(settingVC, animated: true, completion: nil)
        }
    }


}

