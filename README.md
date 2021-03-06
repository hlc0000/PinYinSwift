# PinYinSwift

 `PinYinSwift`是一款基于词库的汉字转换拼音的小工具。

特性:
==============

-  通过词库最大匹配方式进行转换,尽量提高多音字转换准确率。
-  用户可以通过`isDefaultParticiple`这个字段设置为`false`使用系统分词方式进行转换。
-  单个汉字转换通过生成汉字编码方式进行匹配。


关于多音字说明:
-------------------------------------------------------------
想要准确得识别每一条语句中的多音字有两个关键因素,一个是能否准确得给语句进行分词，还有一个就是我们的词库的丰富程度。

示例:
------------------------------
直接传入一个需要转换的String

```
let content = contentFormatter.hanyuPinyinString(content: "你的人生格言是什么？")

let content = contentFormatter.hanyuPinyinString(content: "你的人生格言是什么？",isDefaultParticiple: true)

```

传入一个字符串数组

```
let stringArray = ["济南","石家庄","长春","哈尔滨","沈阳","呼和浩特","乌鲁木齐","兰州","银川","太原","西安","郑州","合肥","南京","杭州","福州","广州","南昌","海口","南宁","贵阳","长沙","武汉","成都","昆明","拉萨","西宁","天津","上海","重庆","北京","台北"]

let queue = DispatchQueue(label: "queue")
queue.async {
    let resultArray = contentFormatter.hanyuPinyinStringArray(array: stringArray)
        for object in resultArray {
            print(object)
        }
    }

``` 

传入一个模型数组类型，并且指定要转换为拼音的属性名称,内部会创建一个transformationModel对象，并且把外部传递进来的模型数组中的模型作为transformationModel中的一个属性

```
@objcMembers class provincialCapital:NSObject {
    var cityName = ""
    var imgString = ""
}
```

```
var provCapiArray = [provincialCapital]()
autoreleasepool {
    for index in 0..<stringArray.count{
        let provCapi = provincialCapital()
        provCapi.cityName = stringArray[index]
        provCapiArray.append(provCapi)
    }
}
```
```
let queue1 = DispatchQueue(label: "queue1")
queue1.async {
    if let resultArray = contentFormatter.hanyuPinyinAnyArray(array: provCapiArray, propertyName: "cityName"){
        for object in resultArray {
            print(object.pinyinName)
        }
    }
}
```

更多测试代码和用例见  `PinYinSwiftDemo`

相关链接:
==============
[PinYinSwift实现](https://juejin.cn/post/6912427072950370317/)
