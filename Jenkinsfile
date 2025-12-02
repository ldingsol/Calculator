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
                    
                    REM 1. Inicia la aplicacion en segundo plano
                    start /b python -m app.calc
                    
                    REM 2. Espera 5 segundos usando PING (Reemplazo de timeout)
                    ping 127.0.0.1 -n 6 > nul
                    
                    REM --- NUEVO ENFOQUE: Captura del PID ---
                    
                    REM 3. Captura toda la salida de netstat a un archivo temporal (netstat_output.tmp)
                    netstat -ano > netstat_output.tmp
                    
                    REM 4. Busca el PID filtrando el archivo temporal
                    for /f "tokens=5" %%i in ('findstr /i :5000 netstat_output.tmp') do (
                        set APP_PID=%%i
                    )
                    
                    REM 5. Escribe el PID capturado a 'pid.txt' para que Groovy lo lea
                    echo !APP_PID! > pid.txt
                '''
                
                script {
                    try {
                        env.APP_PID = readFile('pid.txt').trim()
                    } catch (FileNotFoundException e) {
                        env.APP_PID = ''
                    }
                    
                    if (env.APP_PID == '') {
                        error('Fallo crítico: No se capturó el PID. Verifique si la aplicación inició o si el Agente01 tiene permisos para Netstat/Findstr.')
                    }
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
    } // Cierra el bloque 'stages'
    
    post {
        // Bloque que siempre se ejecuta para limpieza
        always {
            // Lógica de Taskkill y limpieza
            script {
                if (env.APP_PID != null && env.APP_PID.trim() != '') {
                    echo "Deteniendo aplicación Python con PID: ${env.APP_PID}"
                    try {
                        bat "taskkill /F /PID ${env.APP_PID}"
                    } catch (e) {
                        echo "Advertencia: Falló taskkill. El proceso puede haber terminado antes. Error: ${e}"
                    }
                } else {
                    echo 'Advertencia: No se pudo obtener PID para Taskkill. El proceso puede seguir corriendo o ya terminó.'
                }
            }
            cleanWs()
        }
        
        failure {
            echo '🚨 Pipeline fallido. Enviando notificación por correo.'
            
            // =========================================================
            // 🆕 NUEVO ECHO PARA DEPURACIÓN DEL CORREO
            // =========================================================
            echo "Destinatario: ldingsol@gmail.com"
            echo "Asunto: ❌ FALLO Jenkins: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
            echo """
                Cuerpo del correo a enviar:
                El Pipeline ha fallado.
                
                Detalles:
                - Trabajo: ${env.JOB_NAME}
                - Número de Ejecución: ${env.BUILD_NUMBER}
                - Estado: FALLO
                - URL de la Consola: ${env.BUILD_URL}
            """
            // =========================================================
            
            mail(
                to: 'ldingsol@gmail.com', // **¡MODIFICAR ESTA DIRECCIÓN!**
                subject: "❌ FALLO Jenkins: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                    El Pipeline ha fallado.
                    
                    Detalles:
                    - Trabajo: ${env.JOB_NAME}
                    - Número de Ejecución: ${env.BUILD_NUMBER}
                    - Estado: FALLO
                    - URL de la Consola: ${env.BUILD_URL}
                    
                    Por favor, revise el log de Jenkins en el enlace anterior.
                """
            )
        }
    }
} // Cierra el bloque 'pipeline'