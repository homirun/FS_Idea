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
    
    @IBOutlet weak var Segment: UISegmentedControl!
    @IBOutlet var hView: UIView!
    @IBOutlet var hmView: UIView!
    
    @IBOutlet weak var hmNextTime: UILabel!
    @IBOutlet weak var hmWaitTime: UILabel!
    
    @IBOutlet weak var hNextTime: UILabel!
    @IBOutlet weak var hWaitTime: UILabel!
    let baseApiUrl = "https://api.homirun.pw/"
    var apiUrl = ""
    let date = Date()
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hmView.frame = CGRect(x: 0,
                                 y: Segment.frame.minY + Segment.frame.height,
                                 width: self.view.frame.width,
                                 height: (self.view.frame.height - Segment.frame.minY))
        hView.frame = CGRect(x: 0,
                              y: Segment.frame.minY + Segment.frame.height,
                              width: self.view.frame.width,
                              height: (self.view.frame.height - Segment.frame.minY))
        self.view.addSubview(hView)
        self.view.addSubview(hmView)
        getNearTime(place: "hm")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.view.bringSubview(toFront: hmView)
            getNearTime(place: "hm")
        case 1:
            self.view.bringSubview(toFront: hView)
            getNearTime(place: "h")
        default:
            print(sender)
        }
    }
    
    
    func getNearTime(place: String){
        apiUrl = baseApiUrl
        if(place == "hm"){
            apiUrl += "hm/timetable/"
        }else if(place == "h"){
            apiUrl += "h/timetable/"
        }else if(place == "gk"){
            apiUrl += "gk/timetable/"
        }else{
            print("args not found")
        }
        
        let hourFmt = DateFormatter()
        hourFmt.dateFormat = "HH"
        let nowHour = hourFmt.string(from: Date())
        let minuteFmt = DateFormatter()
        minuteFmt.dateFormat = "mm"
        let nowMinute = minuteFmt.string(from: Date())
        var flag = false
        
        Alamofire.request(apiUrl).responseJSON{response in
            switch response.result {
                case .success:
                    let json:JSON = JSON(response.result.value ?? kill)
                    json["Bus"].forEach{(_, data) in
                        let station = data["Station"].string
                        let stationArray =  station?.components(separatedBy: ":")
                        if(place == "hm"){
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
                        }else if(place == "h"){
                            if(flag == false && stationArray![0] != "Shuttle" && Int(nowHour)! == Int(stationArray![0]) && Int(nowMinute)! < Int(stationArray![1])!){
                                flag = true
                                self.hWaitTime.text = String(Int(stationArray![1])! - Int(nowMinute)!) + "分後に発車"
                                self.hNextTime.text = station?.description
                            }
                            else if(flag == false && stationArray![0] != "Shuttle" && Int(nowHour)! < Int(stationArray![0])!){
                                flag = true
                                self.hWaitTime.text = String((60 - Int(nowMinute)!) + Int(stationArray![1])!) + "分後に発車"
                                self.hNextTime.text = station?.description
                                
                            }
                            else if(flag == false && stationArray![0] == "Shuttle"){
                                self.hWaitTime.text = "只今の時間はシャトル運行中です"
                                self.hNextTime.text = ""
                            }
                        }
                    }
                flag = false
                case .failure(let error):
                print(error)

            }
            
        }
    }

    @IBAction func hmReload(_ sender: Any) {
        getNearTime(place: "hm")
    }
    @IBAction func hReload(_ sender: Any) {
        getNearTime(place: "h")
    }
    

}

