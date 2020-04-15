import Foundation
let arr = [1,2]
let i = arr.index(2, offsetBy: 1, limitedBy: arr.endIndex)
print(i)
