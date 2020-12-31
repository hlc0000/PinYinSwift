//
//  String+filtering.swift
//  SearchSwift
//
//  Created by hlc on 2020/12/28.
//

import Foundation

extension String{
    /**
     去掉首尾空格
     */
    var removeHeadAndTailSpace:String{
        let whitespace = CharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    
    /**
     去掉首尾空格 包括后面的换行\n
     */
    var removeHeadAndTailSpacepro:String{
        let whitespace = CharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    
    /**
     去掉所有空格
     */
    var removeAllSapce:String{
        return self.replacingOccurrences(of: "", with: "", options: .literal, range: nil)
    }
     
    // Allows us to use String[index] notation
    subscript(i:Int) -> UniChar{
//            return self[index(startIndex, offsetBy: i)
        return self.utf16[index(startIndex,offsetBy: i)]
    }
    
    //使用正则表达式替换
    func  pregReplace(pattern:  String , with:  String ,
            options:  NSRegularExpression . Options  = []) ->  String  {
    let  regex = try!  NSRegularExpression (pattern: pattern, options: options)
    return  regex.stringByReplacingMatches( in :  self , options: [],
                                            range:  NSMakeRange (0,  self .count),
                                                   withTemplate: with)
    }
    
    func getSubString(fromIndex:Int,toLength:Int)->String{
        let from_index = self.index(self.startIndex, offsetBy: fromIndex)
        let to_index = self.index(self.startIndex, offsetBy: toLength)
        let result = String(self[from_index..<to_index])
        return result
    }
    
    func isIncludeChineseIn() -> Bool {
        for (_, value) in self.enumerated() {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }


}
