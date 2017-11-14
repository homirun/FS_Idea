//
//  FirstViewController.swift
//  FS_test
//
//  Created by homirun on 2017/10/30.
//  Copyright © 2017年 homirun. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class FirstViewController: UIViewController {
    //var items: [JSON] = []
    let apiUrl = "http://10.203.10.144:5000/hm/people/now"
    @IBOutlet weak var waitPeople: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getPeople()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func reload(_ sender: Any) {
        getPeople()
    }
    func getPeople(){
        Alamofire.request(apiUrl).responseString{response in
            self.waitPeople.text = response.result.value! + "人"
            print(response.result.value)
        }
    }
    
}

