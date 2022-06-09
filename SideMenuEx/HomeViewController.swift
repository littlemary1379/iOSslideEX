//
//  HomeViewController.swift
//  SideMenuEx
//
//  Created by onnoffcompany on 2022/06/09.
//

import UIKit

class HomeViewController: UIViewController {


    @IBOutlet weak var sideMenuItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("???")
        // Do any additional setup after loading the view.
        sideMenuItem.target = revealViewController()
        sideMenuItem.action = #selector(revealViewController()?.revealSideMenu)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
