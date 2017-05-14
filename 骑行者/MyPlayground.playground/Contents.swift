//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

print(str)

let timeint :Int?
let formatter  = DateComponentsFormatter()
formatter.allowedUnits = [.minute,.second]
formatter.unitsStyle = .positional
formatter.zeroFormattingBehavior = .pad
let outputString = formatter.string(from: 4555)

let polyline = "1,2;3,4;7,6;3,5"



let polyArray = polyline.components(separatedBy: ";")
    .map() { x in
        let co = x.components(separatedBy: ",")
        //CLLocation(Double(co[0])!, Double(co[1])!)
    }
print(polyArray)
//.map() { x in Double(x)!
//for point in polyArray {
//    print(point[0], point[1])
//}
