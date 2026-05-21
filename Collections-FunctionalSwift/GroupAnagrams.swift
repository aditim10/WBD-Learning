// Group Anagrams -> sort each word -> use as dictionary key -> group matching words under it 

let words = ["listen", "silent", "enlist", "rat", "tar"]

var groups: [String: [String]] = [:]

for word in words 
{
    let key = String(word.sorted())
    groups[key, default: []].append(word)
}

let output = Array(groups.values)
print(output)

// [["listen", "silent", "enlist"], ["rat", "tar"]]