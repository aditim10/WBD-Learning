func add(_ a: Int, _ b: Int) -> Int //fucntion for addition
{
    return a + b
}

func subtract(_ a: Int, _ b: Int) -> Int
{
    return a - b
}

func multiply(_ a: Int, _ b: Int) -> Int
{
    return a * b
}

func divide(_ a: Int, _ b: Int) -> Int
{
    return a / b
}

func modulus(_ a: Int, _ b: Int) -> Int
{
    return a % b
}

let num1 = 20
let num2 = 3

print("Addition: \(add(num1, num2))")
print("Subtraction: \(subtract(num1, num2))")
print("Multiplication: \(multiply(num1, num2))")
print("Division: \(divide(num1, num2))")
print("Modulus: \(modulus(num1, num2))")
