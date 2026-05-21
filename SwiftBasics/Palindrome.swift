let word = "madam"
var isPalindrome = true
let characters = Array(word)
var left = 0
var right = characters.count - 1

while left < right 
{

    if characters[left] != characters[right] 
	{
       		isPalindrome = false
        	break
    	}

    left += 1
    right -= 1
}

if isPalindrome 
{
    print("\(word) is a palindrome")
} 
else 
{
    print("\(word) is not a palindrome")
}