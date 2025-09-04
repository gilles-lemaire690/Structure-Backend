package com.NND.tech.Structure_Backend.controller;

import com.NND.tech.Structure_Backend.StructureBackendApplication;
import com.NND.tech.Structure_Backend.model.Structure;
import com.NND.tech.Structure_Backend.model.Transaction;
import com.NND.tech.Structure_Backend.model.TransactionStatus;
import com.NND.tech.Structure_Backend.model.User;
import com.NND.tech.Structure_Backend.model.UserRole;
import com.NND.tech.Structure_Backend.repository.StructureRepository;
import com.NND.tech.Structure_Backend.repository.TransactionRepository;
import com.NND.tech.Structure_Backend.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest(classes = StructureBackendApplication.class)
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class StatsControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private StructureRepository structureRepository;

    @Autowired
    private UserRepository userRepository;

    private Structure testStructure;
    private User testUser;
    private final LocalDate today = LocalDate.now();

    @BeforeEach
    void setUp() {
        // Nettoyer les données avant chaque test
        transactionRepository.deleteAll();
        userRepository.deleteAll();
        structureRepository.deleteAll();
        
        // Créer une structure de test
        testStructure = new Structure();
        testStructure.setName("Test Structure");
        testStructure.setAddress("123 Test St");
        testStructure.setIsActive(true);
        testStructure = structureRepository.save(testStructure);

        // Créer un utilisateur de test
        testUser = new User();
        testUser.setFirstname("John");
        testUser.setLastname("Doe");
        testUser.setEmail("john.doe@example.com");
        testUser.setRole(UserRole.ADMIN);
        testUser.setStructure(testStructure);
        testUser = userRepository.save(testUser);

        // Ajouter des transactions de test
        addTestTransactions();
    }
    
    private void addTestTransactions() {
        // Transaction d'aujourd'hui pour la structure de test
        Transaction transaction1 = new Transaction();
        transaction1.setAmount(new BigDecimal("100.00"));
        transaction1.setStatus(TransactionStatus.COMPLETED);
        transaction1.setTransactionDate(LocalDateTime.now());
        transaction1.setUser(testUser);
        transaction1.setStructure(testStructure);
        transactionRepository.save(transaction1);
        
        // Transaction d'il y a 2 mois
        Transaction transaction2 = new Transaction();
        transaction2.setAmount(new BigDecimal("200.00"));
        transaction2.setStatus(TransactionStatus.COMPLETED);
        transaction2.setTransactionDate(LocalDateTime.now().minusMonths(2));
        transaction2.setUser(testUser);
        transaction2.setStructure(testStructure);
        transactionRepository.save(transaction2);
        
        // Transaction annulée (ne doit pas compter dans les statistiques)
        Transaction transaction3 = new Transaction();
        transaction3.setAmount(new BigDecimal("50.00"));
        transaction3.setStatus(TransactionStatus.CANCELLED);
        transaction3.setTransactionDate(LocalDateTime.now());
        transaction3.setUser(testUser);
        transaction3.setStructure(testStructure);
        transactionRepository.save(transaction3);
    }

    @Test
    void getGlobalStats_ShouldReturnStats() throws Exception {
        mockMvc.perform(get("/api/stats"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalTransactions").value(2)) // 2 transactions complétées
                .andExpect(jsonPath("$.totalRevenue").value(300.00)) // 100 + 200
                .andExpect(jsonPath("$.totalStructures").value(1))
                .andExpect(jsonPath("$.totalUsers").value(1));
    }

    @Test
    void getStatsByDateRange_ShouldReturnStats() throws Exception {
        String startDate = today.minusDays(1).toString();
        String endDate = today.plusDays(1).toString();

        mockMvc.perform(get("/api/stats/by-date-range")
                        .param("startDate", startDate)
                        .param("endDate", endDate)
                        .param("structureId", testStructure.getId().toString()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.transactionsInPeriod").value(1))
                .andExpect(jsonPath("$.revenueInPeriod").value(100.00));
    }
    
    @Test
    void getStatsByDateRange_ShouldReturnAllPeriodStats_WhenNoDatesProvided() throws Exception {
        mockMvc.perform(get("/api/stats/by-date-range"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.transactionsInPeriod").value(2))
                .andExpect(jsonPath("$.revenueInPeriod").value(300.00));
    }

    @Test
    void getStatsByDateRange_ShouldReturnBadRequest_WhenDatesInvalid() throws Exception {
        String startDate = today.plusMonths(1).toString();
        String endDate = today.minusMonths(1).toString();

        mockMvc.perform(get("/api/stats/by-date-range")
                        .param("startDate", startDate)
                        .param("endDate", endDate))
                .andExpect(status().isBadRequest());
    }

    @Test
    void getStatsByStructure_ShouldReturnStats() throws Exception {
        mockMvc.perform(get("/api/stats/by-structure/{structureId}", testStructure.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.structureId").value(testStructure.getId().intValue()))
                .andExpect(jsonPath("$.structureName").value(testStructure.getName()))
                .andExpect(jsonPath("$.totalTransactions").value(2))
                .andExpect(jsonPath("$.totalRevenue").value(300.00))
                .andExpect(jsonPath("$.averageTransactionAmount").value(150.00));
    }

    @Test
    void getStatsByStructure_ShouldReturnNotFound_WhenStructureNotExists() throws Exception {
        long nonExistentId = 9999L;
        
        mockMvc.perform(get("/api/stats/by-structure/{structureId}", nonExistentId))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.message").value("Structure non trouvée avec l'ID : " + nonExistentId));
    }
    
    @Test
    void getMonthlyStats_ShouldReturnMonthlyStats() throws Exception {
        int year = LocalDate.now().getYear();
        
        mockMvc.perform(get("/api/stats/monthly")
                        .param("year", String.valueOf(year))
                        .param("structureId", testStructure.getId().toString()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.year").value(year))
                .andExpect(jsonPath("$.monthlyData").isArray())
                .andExpect(jsonPath("$.monthlyData[?(@.month == "" + LocalDate.now().getMonthValue() + "")].revenue").value(100.00));
    }
}
