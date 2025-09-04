package com.NND.tech.Structure_Backend.service;

import com.NND.tech.Structure_Backend.dto.TransactionDto;
import com.NND.tech.Structure_Backend.exception.ResourceNotFoundException;
import com.NND.tech.Structure_Backend.mapper.TransactionMapper;
import com.NND.tech.Structure_Backend.model.Structure;
import com.NND.tech.Structure_Backend.model.Transaction;
import com.NND.tech.Structure_Backend.model.TransactionStatus;
import com.NND.tech.Structure_Backend.model.User;
import com.NND.tech.Structure_Backend.repository.TransactionRepository;
import com.NND.tech.Structure_Backend.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TransactionServiceTest {

    @Mock
    private TransactionRepository transactionRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private TransactionMapper transactionMapper;

    @InjectMocks
    private TransactionService transactionService;

    private Transaction testTransaction;
    private TransactionDto testTransactionDto;
    private final Long transactionId = 1L;
    private final Long userId = 1L;

    @BeforeEach
    void setUp() {
        // Create test structure
        Structure structure = new Structure();
        structure.setId(1L);
        structure.setName("Test Structure");

        // Create test user
        User user = new User();
        user.setId(userId);
        user.setFirstname("John");
        user.setLastname("Doe");
        user.setEmail("john.doe@example.com");
        user.setStructure(structure);

        // Create test transaction
        testTransaction = new Transaction();
        testTransaction.setId(transactionId);
        testTransaction.setAmount(new BigDecimal("100.00"));
        testTransaction.setStatus(TransactionStatus.COMPLETED);
        testTransaction.setTransactionDate(LocalDateTime.now());
        testTransaction.setUser(user);
        testTransaction.setStructure(structure);

        // Create test DTO
        testTransactionDto = new TransactionDto();
        testTransactionDto.setId(transactionId);
        testTransactionDto.setAmount(new BigDecimal("100.00"));
        testTransactionDto.setStatus(TransactionStatus.COMPLETED);
        testTransactionDto.setTransactionDate(LocalDateTime.now());
        testTransactionDto.setUserId(userId);
        testTransactionDto.setStructureId(1L);
    }

    @Test
    void createTransaction_ShouldReturnCreatedTransaction() {
        // Arrange
        when(transactionMapper.toEntity(any(TransactionDto.class))).thenReturn(testTransaction);
        when(userRepository.findById(userId)).thenReturn(Optional.of(testTransaction.getUser()));
        when(transactionRepository.save(any(Transaction.class))).thenReturn(testTransaction);
        when(transactionMapper.toDto(any(Transaction.class))).thenReturn(testTransactionDto);

        // Act
        TransactionDto result = transactionService.createTransaction(testTransactionDto);

        // Assert
        assertNotNull(result);
        assertEquals(testTransactionDto.getAmount(), result.getAmount());
        assertEquals(testTransactionDto.getStatus(), result.getStatus());
        verify(transactionRepository, times(1)).save(any(Transaction.class));
    }

    @Test
    void getTransactionById_ShouldReturnTransaction_WhenFound() {
        // Arrange
        when(transactionRepository.findById(transactionId)).thenReturn(Optional.of(testTransaction));
        when(transactionMapper.toDto(any(Transaction.class))).thenReturn(testTransactionDto);

        // Act
        TransactionDto result = transactionService.getTransactionById(transactionId);

        // Assert
        assertNotNull(result);
        assertEquals(transactionId, result.getId());
        verify(transactionRepository, times(1)).findById(transactionId);
    }

    @Test
    void getTransactionById_ShouldThrowException_WhenNotFound() {
        // Arrange
        when(transactionRepository.findById(transactionId)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(ResourceNotFoundException.class, () -> {
            transactionService.getTransactionById(transactionId);
        });
        verify(transactionRepository, times(1)).findById(transactionId);
    }

    @Test
    void getTransactionsByUserId_ShouldReturnUserTransactions() {
        // Arrange
        List<Transaction> transactions = Arrays.asList(testTransaction);
        when(transactionRepository.findByUserId(userId)).thenReturn(transactions);
        when(transactionMapper.toDto(any(Transaction.class))).thenReturn(testTransactionDto);

        // Act
        List<TransactionDto> result = transactionService.getTransactionsByUserId(userId);

        // Assert
        assertEquals(1, result.size());
        verify(transactionRepository, times(1)).findByUserId(userId);
    }

    @Test
    void getTransactionsByStructureId_ShouldReturnStructureTransactions() {
        // Arrange
        Long structureId = 1L;
        List<Transaction> transactions = Arrays.asList(testTransaction);
        when(transactionRepository.findByStructureId(structureId)).thenReturn(transactions);
        when(transactionMapper.toDto(any(Transaction.class))).thenReturn(testTransactionDto);

        // Act
        List<TransactionDto> result = transactionService.getTransactionsByStructureId(structureId);

        // Assert
        assertEquals(1, result.size());
        verify(transactionRepository, times(1)).findByStructureId(structureId);
    }

    @Test
    void updateTransactionStatus_ShouldUpdateStatus_WhenTransactionExists() {
        // Arrange
        TransactionStatus newStatus = TransactionStatus.CANCELLED;
        when(transactionRepository.findById(transactionId)).thenReturn(Optional.of(testTransaction));
        when(transactionRepository.save(any(Transaction.class))).thenReturn(testTransaction);
        when(transactionMapper.toDto(any(Transaction.class))).thenAnswer(invocation -> {
            Transaction t = invocation.getArgument(0);
            testTransactionDto.setStatus(t.getStatus());
            return testTransactionDto;
        });

        // Act
        TransactionDto result = transactionService.updateTransactionStatus(transactionId, newStatus);

        // Assert
        assertNotNull(result);
        assertEquals(newStatus, result.getStatus());
        verify(transactionRepository, times(1)).findById(transactionId);
        verify(transactionRepository, times(1)).save(any(Transaction.class));
    }

    @Test
    void calculateTotalRevenue_ShouldReturnCorrectSum() {
        // Arrange
        Long structureId = 1L;
        when(transactionRepository.sumAmountByStructureId(structureId))
            .thenReturn(new BigDecimal("1000.00"));

        // Act
        BigDecimal result = transactionService.calculateTotalRevenue(structureId);

        // Assert
        assertEquals(0, new BigDecimal("1000.00").compareTo(result));
        verify(transactionRepository, times(1)).sumAmountByStructureId(structureId);
    }

    @Test
    void getTransactionCount_ShouldReturnCorrectCount() {
        // Arrange
        Long structureId = 1L;
        when(transactionRepository.countByStructureId(structureId)).thenReturn(5L);

        // Act
        long result = transactionService.getTransactionCount(structureId);

        // Assert
        assertEquals(5L, result);
        verify(transactionRepository, times(1)).countByStructureId(structureId);
    }

    @Test
    void getTransactionsByDateRange_ShouldReturnFilteredTransactions() {
        // Arrange
        Long structureId = 1L;
        LocalDateTime startDate = LocalDateTime.now().minusDays(7);
        LocalDateTime endDate = LocalDateTime.now();
        List<Transaction> transactions = Arrays.asList(testTransaction);
        
        when(transactionRepository.findByStructureIdAndTransactionDateBetween(
            eq(structureId), any(LocalDateTime.class), any(LocalDateTime.class)))
            .thenReturn(transactions);
        when(transactionMapper.toDto(any(Transaction.class))).thenReturn(testTransactionDto);

        // Act
        List<TransactionDto> result = transactionService.getTransactionsByDateRange(
            structureId, startDate, endDate);

        // Assert
        assertEquals(1, result.size());
        verify(transactionRepository, times(1)).findByStructureIdAndTransactionDateBetween(
            eq(structureId), any(LocalDateTime.class), any(LocalDateTime.class));
    }
}
