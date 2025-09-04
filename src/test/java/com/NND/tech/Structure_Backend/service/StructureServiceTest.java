package com.NND.tech.Structure_Backend.service;

import com.NND.tech.Structure_Backend.dto.StructureDto;
import com.NND.tech.Structure_Backend.exception.ResourceNotFoundException;
import com.NND.tech.Structure_Backend.mapper.StructureMapper;
import com.NND.tech.Structure_Backend.model.Structure;
import com.NND.tech.Structure_Backend.repository.StructureRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class StructureServiceTest {

    @Mock
    private StructureRepository structureRepository;

    @Mock
    private StructureMapper structureMapper;

    @InjectMocks
    private StructureService structureService;

    private Structure testStructure;
    private StructureDto testStructureDto;
    private final Long structureId = 1L;

    @BeforeEach
    void setUp() {
        testStructure = new Structure();
        testStructure.setId(structureId);
        testStructure.setName("Test Structure");
        testStructure.setAddress("123 Test St");
        testStructure.setIsActive(true);

        testStructureDto = new StructureDto();
        testStructureDto.setId(structureId);
        testStructureDto.setName("Test Structure");
        testStructureDto.setAddress("123 Test St");
        testStructureDto.setIsActive(true);
    }

    @Test
    void createStructure_ShouldReturnCreatedStructure() {
        // Arrange
        when(structureMapper.toEntity(any(StructureDto.class))).thenReturn(testStructure);
        when(structureRepository.save(any(Structure.class))).thenReturn(testStructure);
        when(structureMapper.toDto(any(Structure.class))).thenReturn(testStructureDto);

        // Act
        StructureDto result = structureService.createStructure(testStructureDto);

        // Assert
        assertNotNull(result);
        assertEquals(testStructureDto.getName(), result.getName());
        assertEquals(testStructureDto.getAddress(), result.getAddress());
        verify(structureRepository, times(1)).save(any(Structure.class));
    }

    @Test
    void getStructureById_ShouldReturnStructure_WhenFound() {
        // Arrange
        when(structureRepository.findById(structureId)).thenReturn(Optional.of(testStructure));
        when(structureMapper.toDto(any(Structure.class))).thenReturn(testStructureDto);

        // Act
        StructureDto result = structureService.getStructureById(structureId);

        // Assert
        assertNotNull(result);
        assertEquals(testStructureDto.getId(), result.getId());
        verify(structureRepository, times(1)).findById(structureId);
    }

    @Test
    void getStructureById_ShouldThrowException_WhenNotFound() {
        // Arrange
        when(structureRepository.findById(structureId)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(ResourceNotFoundException.class, () -> {
            structureService.getStructureById(structureId);
        });
        verify(structureRepository, times(1)).findById(structureId);
    }

    @Test
    void getAllStructures_ShouldReturnAllStructures() {
        // Arrange
        Structure structure2 = new Structure();
        structure2.setId(2L);
        structure2.setName("Another Structure");
        
        StructureDto structureDto2 = new StructureDto();
        structureDto2.setId(2L);
        structureDto2.setName("Another Structure");
        
        List<Structure> structures = Arrays.asList(testStructure, structure2);
        when(structureRepository.findAll()).thenReturn(structures);
        when(structureMapper.toDto(testStructure)).thenReturn(testStructureDto);
        when(structureMapper.toDto(structure2)).thenReturn(structureDto2);

        // Act
        List<StructureDto> result = structureService.getAllStructures();

        // Assert
        assertEquals(2, result.size());
        verify(structureRepository, times(1)).findAll();
    }

    @Test
    void updateStructure_ShouldReturnUpdatedStructure() {
        // Arrange
        StructureDto updatedDto = new StructureDto();
        updatedDto.setName("Updated Name");
        updatedDto.setAddress("456 New Address");
        updatedDto.setIsActive(false);

        when(structureRepository.findById(structureId)).thenReturn(Optional.of(testStructure));
        when(structureRepository.save(any(Structure.class))).thenReturn(testStructure);
        when(structureMapper.toDto(any(Structure.class))).thenReturn(updatedDto);

        // Act
        StructureDto result = structureService.updateStructure(structureId, updatedDto);

        // Assert
        assertNotNull(result);
        assertEquals(updatedDto.getName(), result.getName());
        assertEquals(updatedDto.getAddress(), result.getAddress());
        assertFalse(result.getIsActive());
        verify(structureRepository, times(1)).findById(structureId);
        verify(structureRepository, times(1)).save(any(Structure.class));
    }

    @Test
    void deleteStructure_ShouldDeleteStructure() {
        // Arrange
        when(structureRepository.existsById(structureId)).thenReturn(true);
        doNothing().when(structureRepository).deleteById(structureId);

        // Act
        structureService.deleteStructure(structureId);

        // Assert
        verify(structureRepository, times(1)).deleteById(structureId);
    }

    @Test
    void deleteStructure_ShouldThrowException_WhenStructureNotFound() {
        // Arrange
        when(structureRepository.existsById(structureId)).thenReturn(false);

        // Act & Assert
        assertThrows(ResourceNotFoundException.class, () -> {
            structureService.deleteStructure(structureId);
        });
        verify(structureRepository, never()).deleteById(anyLong());
    }
}
