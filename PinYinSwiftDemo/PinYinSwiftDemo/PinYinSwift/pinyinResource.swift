//
//  pinyinResource.swift
//  SearchSwift
//
//  Created by hlc on 2020/12/26.
//

import Foundation

class pinyinResource {
    static var termsToPinyinTable:Dictionary? = [String:String]()
    static var charToPinyinTable:Dictionary? = [String:String]();
    static private var pinyinResult:String = ""
    
    /**
     读取txt文件
     */
    static private func getPinyinRecordTable(resourceName:String,extensionName:String,separated:String)->[String:String]?{
        var pinyinTable:Dictionary? = [String:String]();
        if let resource_name = Bundle.main.url(forResource: resourceName, withExtension: extensionName){
            let dictionaryText = try? String(contentsOf: resource_name,encoding: String.Encoding.utf8)
            autoreleasepool {
                if let lines = dictionaryText?.split(separator: "\r\n"){
                    for (_,obj) in lines.enumerated() {
                        let lineComponents = obj.components(separatedBy: separated)
                        var key = lineComponents[0]
                        key = key.pregReplace(pattern: " ", with: "")
                        let value = lineComponents[1]
                        pinyinTable?[key] = value
                    }
                }
            }
        }
        print("11111")
        return pinyinTable
    }
    
    /**
     进行拼音转换
     content:需要转换的内容
     */
    static var parContents = [String]()
    static func hanyuToPinyin(content:String,isDefaultParticiple:Bool)->String{
        if termsToPinyinTable?.count == 0{ termsToPinyinTable = getPinyinRecordTable(resourceName: "unicode_sentenceto_pinyin", extensionName: "txt", separated: ":")}
        if charToPinyinTable?.count == 0{ charToPinyinTable = getPinyinRecordTable(resourceName: "unicode_to_hanyu_pinyin", extensionName: "txt", separated: " ")}
        if(isDefaultParticiple == true){
            /**
             使用最大分词算法
             */
            let result = hanyuMaxParticiple(content: content)
            pinyinResult = result
        }else{
            /**使用默认分词*/
            parContents = hanyuDefaultParticiple(content: content)
            convert(index: 0)
        }
        return pinyinResult
    }
    
    /**
     把分词好的数据转换为拼音
     */
    static private func convert(index:Int){
        var currentIndex = index
        let content = parContents[currentIndex]
        
        let result = getPinyinRecord(content: content)
        pinyinResult.append(result)
        currentIndex+=1
        if(currentIndex < parContents.count){ convert(index: currentIndex) }
    }
    
    /**
     查找unicode_sentenceto_pinyin中对应数据,如果没有数据，返回nil
     */
    static private func getTermsToPinyinRecord(content:String)->String?{
        if let termsPinyin = termsToPinyinTable?[content]{
            var resultPinyin = ""
            resultPinyin = termsPinyin.pregReplace(pattern: "[1-5]", with: "")
            resultPinyin = resultPinyin.pregReplace(pattern: " ", with: "")
            return resultPinyin
        }
        return nil
    }
    
    /**
     单个文字转换拼音
     */
    static private func getCharToPinyinRecord(content:String)->String?{
        let unContent = content[0]
        let codepointHexStr = String(format: "%x", unContent).uppercased()
        let record = charToPinyinTable?[codepointHexStr]
        if let pinyinStr = record?.components(separatedBy: ","){
            var pinyin = pinyinStr[0]
            pinyin = pinyin.pregReplace(pattern: "[1-5]", with: "")
            return pinyin
        }
        return nil
    }
    
    /**
     使用系统API分词
     */
    static private func hanyuDefaultParticiple(content:String)->[String]{
        var contents = [String]();
        if content.count == 1{ contents.append(content) }
        var tempContent = ""
        let ref = CFStringTokenizerCreate(nil, content as CFString, CFRangeMake(0, content.count), kCFStringTokenizerUnitWord, nil)
        CFStringTokenizerAdvanceToNextToken(ref);
        var range = CFStringTokenizerGetCurrentTokenRange(ref)
        while range.length>0 {
            tempContent = content.getSubString(fromIndex: range.location, toLength: range.location + range.length)
            contents.append(tempContent)
            CFStringTokenizerAdvanceToNextToken(ref)
            range = CFStringTokenizerGetCurrentTokenRange(ref)
        }
        return contents
    }
    
    
    
    static private func getPinyinRecord(content:String)->String{
        let resultPinyin = hanyuSubString(content: content,index: 0)
        return resultPinyin
    }
    
    static private func hanyuSubString(content:String,index:Int)->String{
        var inLength = 1, currentIndex = index
        if(content.count > 1){ inLength = content.count}
        var result = ""
        autoreleasepool {
            while inLength > currentIndex {
                let tempContent = content.getSubString(fromIndex: currentIndex, toLength: inLength)
                if(tempContent.count == 1){
                    if let pinyin = getCharToPinyinRecord(content: tempContent){
                        currentIndex+=1
                        inLength = content.count
                        result.append(pinyin)
                        continue
                    }
                    currentIndex+=1
                    inLength = content.count
                    result.append(tempContent)
                    continue
                }
                if let pinyin = getTermsToPinyinRecord(content: tempContent){
                    currentIndex+=tempContent.count
                    inLength = content.count
                    result.append(pinyin)
                    continue
                }
                
                if inLength-1 != currentIndex{ inLength -= 1 }
            }
        }
        return result
    }
    
    /**
     使用最大分词算法
     */
    static private func hanyuMaxParticiple(content:String)->String{
        let result = pinSubString(content: content, index: 0)
        return result
    }
    
    static private func pinSubString(content:String,index:Int)->String{
        var inLength = 1,currentIndex = index
        if content.count > MAXLENGTH{ inLength = MAXLENGTH }
        else{ inLength = content.count }
        var result = ""
        autoreleasepool {
            while inLength > currentIndex{
                let tempContent = content.getSubString(fromIndex: currentIndex, toLength: inLength)
                if tempContent.count == 1{
                    if let pinyin = getCharToPinyinRecord(content: tempContent){
                        result.append(pinyin)
                        currentIndex+=1
                        if currentIndex + MAXLENGTH > content.count{ inLength = content.count }
                        else{ inLength = MAXLENGTH + currentIndex }
                        continue
                    }
                    result.append(tempContent)
                    currentIndex+=1
                    if currentIndex + MAXLENGTH > content.count{ inLength = content.count }
                    else{ inLength = MAXLENGTH + currentIndex }
                    continue
                }
                
                if let pinyin = getTermsToPinyinRecord(content: tempContent){
                    result.append(pinyin)
                    currentIndex+=tempContent.count
                    if currentIndex + MAXLENGTH > content.count{ inLength = content.count }
                    else{ inLength = MAXLENGTH + currentIndex }
                }
                
                if inLength-1 != currentIndex{ inLength -= 1 }
            }
        }
        return result
    }
}
