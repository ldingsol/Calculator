pipeline {
    agent {
        // Ejecutar en el agente configurado para Python/Java/Maven
        node { label 'Agente01' }
    }
    options {
        // Permite archivar artefactos de ejecuciones fallidas (útil para reportes)
        skipStagesAfterUnstable()
    }
    stages {
        stage('Declarative: Checkout SCM') {
            steps {
                // Clonar el repositorio
                checkout scm
            }
        }
        
        stage('Build & Install Python Dependencies') {
            steps {
                echo 'Instalando y actualizando dependencias de Python (para código de aplicación)'
                // 1. Instala/Actualiza las dependencias de Python
                bat 'pip install --upgrade -r requirements.txt' 
            }
        }
               
        stage('Run Integration Tests (Karate)') {
            steps {
                echo 'Ejecutando pruebas de Karate via Maven'
                // 3. Ejecutar Karate DSL usando Maven. 
                //    El comando 'clean test' asume que tu pom.xml está configurado
                //    para ejecutar las pruebas de Karate.
                bat 'mvn clean test'
            }
        }
    }
    
    post {
        always {
            // 4. Archivar los resultados de los tests.
            //    Los resultados de Karate vía Maven se guardan en el directorio 'target/surefire-reports'.
            junit 'target/surefire-reports/*.xml' 
            
            // Archivar los resultados de Python (si la etapa se mantuvo)
            junit 'results/python_test_result.xml'
            
            cleanWs()
        }
    }
}