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
        
        // ¡IMPORTANTE! Mantener '%%i' para el loop y usar Delayed Expansion.
        bat '''
            SETLOCAL ENABLEDELAYEDEXPANSION
            
            REM Inicia la aplicacion como modulo en segundo plano
            start /b python -m app.calc
            
            REM Espera 5 segundos para que la aplicación se enlace al puerto 5000
            timeout /t 5 /nobreak
            
            REM Captura el PID (Usar doble %% para la variable de loop en Jenkins)
            for /f "tokens=5" %%i in ('netstat -ano ^| findstr /i :5000') do (
                set APP_PID=%%i
            )
            
            REM El PID se asigna a la variable de Jenkins
            echo Setting Jenkins ENV variable APP_PID to: !APP_PID!
            echo !APP_PID! > pid.txt
        '''
        // Leer el PID capturado del archivo temporal y asignarlo a la variable de entorno de Jenkins
        script {
            env.APP_PID = readFile('pid.txt').trim()
        }
        echo "Application started with Jenkins ENV PID: ${env.APP_PID}"
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