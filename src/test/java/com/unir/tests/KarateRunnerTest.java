package com.unir.tests;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.DisplayName;

public class KarateRunnerTest {

    @Karate.Test
    @DisplayName("Ejecutar todas las pruebas de la API Calculator")
    Karate runAllTests() {
        // SOLUCIÓN FINAL: Usamos solo la ruta de sistema de archivos ("src/test/features") 
        // sin .relativeTo(getClass()) para evitar la concatenación de paquetes.
        return Karate.run("src/test/features")
                .tags("~@ignore"); // Ejecutar todas las pruebas que no tengan el tag @ignore
    }
}
