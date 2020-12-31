//
//  contentFormatter.swift
//  SearchSwift
//
//  Created by hlc on 2020/12/26.
//

import Foundation

class transformationModel{
    var pinyinName:String = ""
    var model:AnyObject
    init(model:AnyObject) {
        self.model = model
    }
}

public class contentFormatter{
    /**
     传入一个[String],把数组中的所有的String转换为拼音
     isDefaultParticiple:true 使用最大匹配算法 false:使用系统API进行分词
     */
    static func hanyuPinyinStringArray(array:Array<String>,isDefaultParticiple:Bool=true)->[String]{
        var stringArray = [String]()
        for object in array {
            if object == ""{ stringArray.append(object)
                continue }
            let pinyinResult =  pinyinResource.hanyuToPinyin(content: object,isDefaultParticiple: isDefaultParticiple)
            stringArray.append(pinyinResult)
        }
        return stringArray
    }
    
    /**
     传入一个[String],把数组中的所有的String转换为拼音
     isDefaultParticiple:true 使用最大匹配算法 false:使用系统API进行分词
     */
    static func hanyuPinyinString(content:String,isDefaultParticiple:Bool=true)->String{
        if content == ""{ return content }
       return pinyinResource.hanyuToPinyin(content: content,isDefaultParticiple: isDefaultParticiple)
    }
    
    /**
     传入一个[AnyObject]并指定需要转为拼音的字段
     isDefaultParticiple:true 使用最大匹配算法 false:使用系统API进行分词
     return 返回一个包含拼音以及数据模型的数组
     */
    static func hanyuPinyinAnyArray(array:Array<AnyObject>,propertyName:String,isDefaultParticiple:Bool=true)->[transformationModel]?{
        var transArray = [transformationModel]()
        for object in array {
            let transformation_model = transformationModel(model: object)
            guard let content = getValueOfProperty(object: object,propertyName: propertyName) else{ return nil }
            let pinyinResult =  pinyinResource.hanyuToPinyin(content: content,isDefaultParticiple: isDefaultParticiple)
            transformation_model.pinyinName = pinyinResult
            transArray.append(transformation_model)
        }
        return transArray
    }
    
    static private func getValueOfProperty(object:AnyObject,propertyName:String)->String?{
        var count: UInt32 = 0;
        let cls: AnyClass? = object_getClass(object);
        guard let propertys = class_copyPropertyList(cls, &count) else{ return nil }
        for index in 0..<count {
            let property = propertys[Int(index)]
            let char_name = property_getName(property)
            let property_name = String.init(utf8String: char_name)
            if property_name == propertyName{
                let name = object.value(forKey:propertyName) as? String
                return name
            }
        }
        return nil
    }
}

