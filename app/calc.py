import app
import math 


class InvalidPermissions(Exception):
    pass


class Calculator:
    def add(self, x, y):
        self.check_types(x, y)
        return x + y

    def substract(self, x, y):
        self.check_types(x, y)
        return x - y

    def multiply(self, x, y):

        if not app.util.validate_permissions(f"{x} * {y}", "user1"):
            raise InvalidPermissions('User has no permissions')

        self.check_types(x, y)
        return x * y

    def divide(self, x, y):
        self.check_types(x, y)
        if y == 0:
            raise TypeError("Division by zero is not possible")

        return x / y

    def power(self, x, y):
        self.check_types(x, y)
        return x ** y

    def square_root(self, x):

        self.check_types(x, 1)
        if x < 0:
            raise TypeError("Cannot calculate the square root of a negative number")
        
        return math.sqrt(x)

    def log_base_10(self, x):
        
        self.check_types(x, 1)
        if x <= 0:
            raise TypeError("Cannot calculate logarithm for zero or negative numbers")
        
        return math.log10(x)

    def check_types(self, x, y):
        if not isinstance(x, (int, float)) or not isinstance(y, (int, float)):
            raise TypeError("Parameters must be numbers")


if __name__ == "__main__":  
    calc = Calculator()
    result = calc.add(2, 2)
    print(result)
