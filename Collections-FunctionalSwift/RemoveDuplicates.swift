// Remove Duplicates -> Set (to check) + Array (to store) = order preserved + fast lookup

let fruits = ["apple", "banana", "apple", "mango"]

var seen = Set<String>()
var result: [String] = []

for fruit in fruits 
{
    if !seen.contains(fruit) 
{
        seen.insert(fruit)
        result.append(fruit)
    }
}

print(result)
// ["apple", "banana", "mango"]