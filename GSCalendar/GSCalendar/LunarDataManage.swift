//
//  LunarDataManage.swift
//  GSCalendar
//
//  Created by  Moazine on 24/10/2018.
//  Copyright © 2018 goldensmell. All rights reserved.
//

import UIKit

class LunarDataManage: NSObject {

    let lunarFileName = "lunar"
    var lunarData:Dictionary<String,String>?
    
    func convertToDictionary(text: String) -> [String: String]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    // read lunar data file
    public func readLunarData(){
    
        let fileUrlProject = Bundle.main.path(forResource: lunarFileName, ofType: ".txt")
        var lunaStringData = ""
        do{
            lunaStringData = try String(contentsOfFile: fileUrlProject!, encoding: String.Encoding.utf8)
        }catch let error {
            print(error)
        }
        
        lunarData = convertToDictionary(text: lunaStringData)
    }
    
    public func changeSolarsToLunars(_ dates:[Date])-> Array<String> {
        
        var result = Array<String>()
        for date in dates {
            let strDate = date.getDefaultString()
            if let lunarDate = lunarData?[strDate] {
                result.append(lunarDate)
            }else {
                result.append("")
            }
        }
        
        return result
    }
}
