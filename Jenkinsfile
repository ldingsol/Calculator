pipeline {
    agent {
        label 'Agente01'
    }
    stages {
        // La etapa Source está bien, usa el checkout implícito
        stage('Source') {
            steps {
                checkout scm 
            }
        }
        
        stage('Build') {
            steps {
                echo 'Installing dependencies'
                // 1. Instalar dependencias con PIP (asumiendo un requirements.txt)
                // Usamos 'bat' porque estamos en Windows
                bat 'pip install -r requirements.txt' 
                
                // Si el paso de 'Build' es solo instalar dependencias, esto es suficiente.
            }
        }
        
        stage('Unit tests') {
            steps {
                echo 'Running unit tests'
                // 2. Ejecutar pruebas (asumiendo que usas pytest y genera un XML de JUnit)
                // Se debe usar la herramienta de pruebas específica (pytest, nose, unittest, etc.)
                bat 'pytest --junitxml=results/test_result.xml' 
                
                // Archivar el artefacto de la prueba para que la sección 'post' lo use
                archiveArtifacts artifacts: 'results/test_result.xml'
            }
        }
    }
    
    post {
        always {
            // 3. Publicar resultados de pruebas (patrón corregido)
            junit 'results/test_result.xml' 
            cleanWs()
        }
    }
}