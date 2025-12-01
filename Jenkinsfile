pipeline {
    // Definimos el agente donde correrá el pipeline.
    agent {
        label 'Agente01'
    }
    
    stages {
        // ETAPA SIMPLIFICADA: Usamos 'checkout scm' que utiliza la configuración del Job
        stage('Source') {
            steps {
                // Esto asegura que se usa la configuración SCM del Job (que debe apuntar a 'main')
                checkout scm 
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building stage'
                // Revisa si 'make build' es un comando de Windows. Si no, usa 'bat'.
                sh 'make build' 
            }
        }
        
        stage('Unit tests') {
            steps {
                sh 'make test-unit'
                // Revisa que este patrón coincida con el paso 'junit' de abajo
                archiveArtifacts artifacts: 'results/*_result.xml' 
            }
        }
    }
    
    post {
        always {
            // CORREGIDO: Usar el mismo patrón de archivo XML de pruebas.
            junit 'results/*_result.xml' 
            // Limpia el workspace del agente después de cada ejecución (buena práctica).
            cleanWs()
        }
    }
}