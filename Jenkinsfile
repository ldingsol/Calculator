pipeline {
    agent {
        node { label 'Agente01' }
    }
    environment {
        // Variable para almacenar el ID del proceso de la aplicación Python
        APP_PID = ''
    }
    stages {
        stage('Declarative: Checkout SCM') {
            steps {
                checkout scm
            }
        }
        
        stage('Build & Install Python Dependencies') {
            steps {
                echo 'Instalando y actualizando dependencias de Python (para código de aplicación)'
                bat 'pip install --upgrade -r requirements.txt' 
            }
        }
        
        stage('Start Application') {
            steps {
                echo 'Iniciando la aplicación Python en segundo plano...'
                // Ejecutar Flask en background en Windows, y capturar su PID si es posible
                // Usamos 'start /b' en BAT/CMD para ejecutar en background sin abrir una nueva ventana
                // Y luego buscamos el PID del proceso en el puerto 5000 (COMANDO CRÍTICO)
                bat '''
                    start /b python -m app.calc
                    timeout 5
                    for /f "tokens=5" %%i in ('netstat -ano ^| findstr :5000') do (
                        set APP_PID=%%i
                    )
                    echo Application started with PID: %APP_PID%
                '''
                // Si tu archivo principal se llama 'calculator.py', cambia 'python app.py' por 'python calculator.py'
            }
        }
        
        stage('Run Integration Tests (Karate)') {
            steps {
                echo 'Ejecutando pruebas de Karate via Maven'
                // Las pruebas ahora encontrarán la aplicación en 127.0.0.1:5000
                bat 'mvn clean test'
            }
        }
    }
    
    post {
        always {
            // 1. Archivar los reportes de Karate
            junit 'target/surefire-reports/*.xml' 
            
            // 2. Intentar detener el proceso de la aplicación Python
            script {
                if (env.APP_PID != '' && env.APP_PID != ' ') {
                    echo "Deteniendo aplicación Python con PID: ${env.APP_PID}"
                    // Usar 'taskkill /F' para detener el proceso forzadamente en Windows
                    try {
                        bat "taskkill /F /PID ${env.APP_PID}"
                    } catch (e) {
                        echo "Advertencia: Falló taskkill. Puede que el proceso ya haya terminado. ${e}"
                    }
                } else {
                    echo 'No se encontró PID para detener la aplicación.'
                }
            }

            // 3. Limpiar el workspace
            cleanWs()
        }
    }
}