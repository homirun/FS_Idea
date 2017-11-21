//
//  SecondViewController.swift
//  FS_test
//
//  Created by homirun on 2017/10/30.
//  Copyright © 2017年 homirun. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SecondViewController: UIViewController {
    @IBOutlet weak var hmNextTime: UILabel!
    @IBOutlet weak var hmWaitTime: UILabel!
    
    let apiUrl = "http://192.168.1.6:5000/hm/timetable/"
    let date = Date()
    let calendar = Calendar.current
    
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
        let hourFmt = DateFormatter()
        hourFmt.dateFormat = "HH"
        var nowHour = hourFmt.string(from: Date())
        let minuteFmt = DateFormatter()
        minuteFmt.dateFormat = "mm"
        var nowMinute = minuteFmt.string(from: Date())
        var flag = false
        
        Alamofire.request(apiUrl).responseJSON{response in
            //self.text = response.result.value!
            switch response.result {
                case .success:
                    let json:JSON = JSON(response.result.value ?? kill)
                    print(json["Bus"])
                    json["Bus"].forEach{(_, data) in
                        let station = data["Station"].string
                        print(station)
                        let stationArray =  station?.components(separatedBy: ":")
                        //if(stationArray[0] == S)
                        if(flag == false && stationArray![0] != "Shuttle" && Int(nowHour)! == Int(stationArray![0]) && Int(nowMinute)! < Int(stationArray![1])!){
                            flag = true
                            self.hmWaitTime.text = String(Int(stationArray![1])! - Int(nowMinute)!) + "分後に発車"
                            self.hmNextTime.text = station?.description
                        }
                        else if(flag == false && stationArray![0] != "Shuttle" && Int(nowHour)! < Int(stationArray![0])!){
                            flag = true
                            self.hmWaitTime.text = String((60 - Int(nowMinute)!) + Int(stationArray![1])!) + "分後に発車"
                            self.hmNextTime.text = station?.description
                            
                        }
                        else if(flag == false && stationArray![0] == "Shuttle"){
                            self.hmWaitTime.text = "只今の時間はシャトル運行中です"
                            self.hmNextTime.text = ""
                        }
                    }
                flag = false
                case .failure(let error):
                print(error)

            }
            
        }
    }
    @IBAction func reload(_ sender: Any) {
        getNearTime()
    }
    

}

