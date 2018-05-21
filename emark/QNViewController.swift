//
//  QNViewController.swift
//  emark
//
//  Created by huweiya on 2018/5/21.
//  Copyright © 2018年 neebel. All rights reserved.
//

import UIKit

class QNViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let VC = EMHomeViewController();
        VC.title = "ceshi";
        self.navigationController?.pushViewController(VC, animated: true);
        self.view.backgroundColor = UIColor.purple;

    }
    
    func test() -> Void {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
