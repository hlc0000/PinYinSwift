//
//  ViewController.swift
//  PinYinSwiftDemo
//
//  Created by hlc on 2020/12/31.
//

import UIKit

@objcMembers class provincialCapital:NSObject {
    var cityName = ""
    var imgString = ""
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let stringArray = ["济南","石家庄","长春","哈尔滨","沈阳","呼和浩特","乌鲁木齐","兰州","银川","太原","西安","郑州","合肥","南京","杭州","福州","广州","南昌","海口","南宁","贵阳","长沙","武汉","成都","昆明","拉萨","西宁","天津","上海","重庆","北京","台北"]

        let queue = DispatchQueue(label: "queue")
        queue.async {
            let resultArray = contentFormatter.hanyuPinyinStringArray(array: stringArray)
                for object in resultArray {
                    print(object)
                }
            }
        let content = contentFormatter.hanyuPinyinString(content: "春运多地机票价格远低于火车票",isDefaultParticiple: true)
        print(content)

        var provCapiArray = [provincialCapital]()
        autoreleasepool {
            for index in 0..<stringArray.count{
                let provCapi = provincialCapital()
                provCapi.cityName = stringArray[index]
                provCapiArray.append(provCapi)
            }
        }

        let queue1 = DispatchQueue(label: "queue1")
        queue1.async {
            if let resultArray = contentFormatter.hanyuPinyinAnyArray(array: provCapiArray, propertyName: "cityName"){
                for object in resultArray {
                    print(object.pinyinName)
                }
            }
        }
    }

    func getProvincialCapital(provCapi:provincialCapital){
        print(provCapi.cityName,provCapi.imgString)
    }


}

