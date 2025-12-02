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
        
        bat '''
            SETLOCAL ENABLEDELAYEDEXPANSION
            
            REM Inicia la aplicacion como módulo en segundo plano
            start /b python -m app.calc
            
            REM Espera 5 segundos para que la aplicación se enlace al puerto 5000
            timeout /t 5 /nobreak
            
            REM Captura el PID usando netstat. Usa doble %%i en Jenkins.
            for /f "tokens=5" %%i in ('netstat -ano ^| findstr /i :5000') do (
                set APP_PID=%%i
            )
            
            REM Muestra el PID capturado usando !APP_PID! (Delayed Expansion)
            echo Application started with PID: !APP_PID!
        '''
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
            // Asegúrate de que el PID sea capturado (no es nulo o vacío)
            if (env.APP_PID != null && env.APP_PID != ' ') {
                echo "Deteniendo aplicación Python con PID: ${env.APP_PID}"
                bat "taskkill /F /PID ${env.APP_PID}"
            } else {
                    echo 'No se encontró PID para detener la aplicación.'
                }
            }

            // 3. Limpiar el workspace
            cleanWs()
        }
    }
}