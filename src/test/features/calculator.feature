Feature: prueba de ingreso a la API y funcionalidad basica

Scenario: 1. Verificacion de API y Health Check
    Given url base
    When method GET
    Then status 200
    And match response == 'Hello from The Calculator!\n'

Scenario: 2. Prueba se suma de numeros enteros positivos
    Given url base +'/calc/add/10/7'
    When method GET
    Then status 200
    And match response == '17'

Scenario: 3. Prueba de resta con numeros enteros positivos
    Given url base +'/calc/substract/12/9'
    When method GET
    Then status 200
    And match response == '3'

Scenario Outline: 4. Sumas con numeros negativos y decimales
    Given url base +'/calc/add/' + op1 + '/' + op2
    When method GET
    Then status 200
    And match response == expected_result

    Examples:
        | op1 | op2 | expected_result |
        | 10  | -5  | 5               |
        | -10 | -5  | -15             |
        | 8   | -8  | 0               |
        | -20 | -4  | -24             |
        |-60  | 25  | -35             |
        | 12.5|20.75| 33.25           |
        | 0.5 | 9   | 9.5             |
        | 6.8 | -2.9| 3.9             |

Scenario Outline: 5. Restas exitosas de numeros Negativos y positivos
    Given url base +'/calc/substract/' + op1 + '/' + op2
    When method GET
    Then status 200
    And match response == expected_result

    Examples:
    | op1 | op2 | expected_result |
    | 10  | 6   | 4               |
    | 3   | 8   | -5              |
    | 15  | 3   | 12              |
    | 3.2 | -2  | 5.2             |
    | -21 | -2.8| -18.2           |
    | 55  | 25  | 30              |
    | 8.9 | 2.44| 6.460000000000001 |
    | 5.7 | -5.1| 10.8            |
Scenario Outline: 6. Pruebas de manejo de errores y entradas no validas.
    Given url base +'/calc/' + operation + '/' + op1 + '/' + op2
    When method GET
    Then status 400
    And match response contains 'Operator cannot be converted to number'

    Examples:
    | operation | op1 | op2 |
    | add       | a   | 5   |
    | substract | 10  | lik |
    | multiply  | a   | 5   |
    | divide    | 10  | asd |
    | power     | text| 2   |

Scenario Outline: 7. Pruebas de multiplicacion exitosa.
    Given url base +'/calc/multiply/' + op1 + '/' + op2
    When method GET
    Then status 200
    And match response == expected_result

    Examples:
    | op1 | op2 | expected_result   |
    | 5   | 5   | 25                |
    | -2  | 10  | -20               |
    | 2.5 | 2   | 5.0               |
    | 2.8 | 7   | 19.599999999999998|
    | 7.2 | -3  | -21.6             |

Scenario Outline: 8. Pruebas de division exitosa y division entre 0.
    Given url base +'/calc/divide/' + op1 + '/' + op2
    When method GET
    Then status 200
    And match response == expected_result

    Examples: 
    | op1 | op2 | expected_result   |
    | 10  | 2   | 5.0               |
    | 1   | 3   | 0.3333333333333333|
    | 55  | 12  | 4.583333333333333 |

Scenario: 9. Prueba de division entre 0.
    Given url base +'/calc/divide/20/0'
    When method GET
    Then status 400
    And match response == 'Division by zero is not possible'

Scenario Outline: 10. Pruebas de potenciacion exitosa
    Given url base +'/calc/power/' + op1 + '/' + op2
    When method GET
    Then status 200
    And match response == expected_result

    Examples:
    | op1 | op2 | expected_result |
    | 2   | 3   | 8               |
    | 5   | 0   | 1               |
    | 4   | 0.5 | 2.0             |

Scenario Outline: 11. Pruebas de raiz cuadrada exitosas y error
    Given url base +'/calc/sqrt/' + op1
    When method GET
    Then status 200
    And match response == expected_result

    Examples:
    | op1 | expected_result   |
    | 9   | 3.0               | 
    | 0   | 0.0               | 
    | 2   | 1.4142135623730951| 
    | -4  | 'Cannot calculate the square root of a negative number' | 

Scenario Outline: 12. Logaritmo base 10 exitoso, con cero y error.
    Given url base +'/calc/log10/' + op1
    When method GET
    Then status 200
    And match response == expected_result

    Examples: 
    | op1 | expected_result   |
    | 1   | 0.0               |
    | 10  | 1.0               |
    | 1000| 3.0               |
    | -1  | 'Cannot calculate logarithm for zero or negative numbers' | 
    | 0   | 'Cannot calculate logarithm for zero or negative numbers' | 