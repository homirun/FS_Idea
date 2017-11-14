//
//  SecondViewController.swift
//  FS_test
//
//  Created by homirun on 2017/10/30.
//  Copyright © 2017年 homirun. All rights reserved.
//

import UIKit
import Alamofire

class SecondViewController: UIViewController {
    @IBOutlet weak var hmNextTime: UILabel!
    let apiUrl = "http://10.203.10.144:5000/hm/timetable/"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getNearTime()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getNearTime(){
        Alamofire.request(apiUrl).responseString{response in
            self.hmNextTime.text = response.result.value
        }
    }


}

