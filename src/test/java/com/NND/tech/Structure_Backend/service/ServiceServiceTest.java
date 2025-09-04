package com.NND.tech.Structure_Backend.service;

import com.NND.tech.Structure_Backend.dto.ServiceDto;
import com.NND.tech.Structure_Backend.exception.ResourceNotFoundException;
import com.NND.tech.Structure_Backend.mapper.ServiceMapper;
import com.NND.tech.Structure_Backend.model.Service;
import com.NND.tech.Structure_Backend.model.Structure;
import com.NND.tech.Structure_Backend.repository.ServiceRepository;
import com.NND.tech.Structure_Backend.repository.StructureRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ServiceServiceTest {

    @Mock
    private ServiceRepository serviceRepository;

    @Mock
    private StructureRepository structureRepository;

    @Mock
    private ServiceMapper serviceMapper;

    @InjectMocks
    private ServiceService serviceService;

    private Service testService;
    private ServiceDto testServiceDto;
    private final Long serviceId = 1L;
    private final Long structureId = 1L;

    @BeforeEach
    void setUp() {
        // Create test structure
        Structure structure = new Structure();
        structure.setId(structureId);
        structure.setName("Test Structure");

        // Create test service
        testService = new Service();
        testService.setId(serviceId);
        testService.setName("Test Service");
        testService.setDescription("Test Description");
        testService.setPrice(new BigDecimal("100.00"));
        testService.setDuration(60);
        testService.setStructure(structure);

        // Create test DTO
        testServiceDto = new ServiceDto();
        testServiceDto.setId(serviceId);
        testServiceDto.setName("Test Service");
        testServiceDto.setDescription("Test Description");
        testServiceDto.setPrice(new BigDecimal("100.00"));
        testServiceDto.setDuration(60);
        testServiceDto.setStructureId(structureId);
    }

    @Test
    void createService_ShouldReturnCreatedService() {
        // Arrange
        when(structureRepository.findById(structureId)).thenReturn(Optional.of(testService.getStructure()));
        when(serviceMapper.toEntity(any(ServiceDto.class))).thenReturn(testService);
        when(serviceRepository.save(any(Service.class))).thenReturn(testService);
        when(serviceMapper.toDto(any(Service.class))).thenReturn(testServiceDto);

        // Act
        ServiceDto result = serviceService.createService(testServiceDto);

        // Assert
        assertNotNull(result);
        assertEquals(testServiceDto.getName(), result.getName());
        assertEquals(testServiceDto.getPrice(), result.getPrice());
        verify(serviceRepository, times(1)).save(any(Service.class));
    }

    @Test
    void getServiceById_ShouldReturnService_WhenFound() {
        // Arrange
        when(serviceRepository.findById(serviceId)).thenReturn(Optional.of(testService));
        when(serviceMapper.toDto(any(Service.class))).thenReturn(testServiceDto);

        // Act
        ServiceDto result = serviceService.getServiceById(serviceId);

        // Assert
        assertNotNull(result);
        assertEquals(serviceId, result.getId());
        verify(serviceRepository, times(1)).findById(serviceId);
    }

    @Test
    void getServiceById_ShouldThrowException_WhenNotFound() {
        // Arrange
        when(serviceRepository.findById(serviceId)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(ResourceNotFoundException.class, () -> {
            serviceService.getServiceById(serviceId);
        });
        verify(serviceRepository, times(1)).findById(serviceId);
    }

    @Test
    void getServicesByStructure_ShouldReturnServicesForStructure() {
        // Arrange
        List<Service> services = Arrays.asList(testService);
        when(serviceRepository.findByStructureId(structureId)).thenReturn(services);
        when(serviceMapper.toDto(any(Service.class))).thenReturn(testServiceDto);

        // Act
        List<ServiceDto> result = serviceService.getServicesByStructure(structureId);

        // Assert
        assertEquals(1, result.size());
        verify(serviceRepository, times(1)).findByStructureId(structureId);
    }

    @Test
    void getAllServices_ShouldReturnAllServices() {
        // Arrange
        Service service2 = new Service();
        service2.setId(2L);
        service2.setName("Another Service");
        
        ServiceDto serviceDto2 = new ServiceDto();
        serviceDto2.setId(2L);
        serviceDto2.setName("Another Service");
        
        List<Service> services = Arrays.asList(testService, service2);
        when(serviceRepository.findAll()).thenReturn(services);
        when(serviceMapper.toDto(testService)).thenReturn(testServiceDto);
        when(serviceMapper.toDto(service2)).thenReturn(serviceDto2);

        // Act
        List<ServiceDto> result = serviceService.getAllServices();

        // Assert
        assertEquals(2, result.size());
        verify(serviceRepository, times(1)).findAll();
    }

    @Test
    void updateService_ShouldReturnUpdatedService() {
        // Arrange
        ServiceDto updatedDto = new ServiceDto();
        updatedDto.setName("Updated Service");
        updatedDto.setDescription("Updated Description");
        updatedDto.setPrice(new BigDecimal("150.00"));
        updatedDto.setDuration(90);
        updatedDto.setStructureId(structureId);

        when(serviceRepository.findById(serviceId)).thenReturn(Optional.of(testService));
        when(structureRepository.findById(structureId)).thenReturn(Optional.of(testService.getStructure()));
        when(serviceRepository.save(any(Service.class))).thenReturn(testService);
        when(serviceMapper.toDto(any(Service.class))).thenAnswer(invocation -> {
            Service s = invocation.getArgument(0);
            testServiceDto.setName(s.getName());
            testServiceDto.setDescription(s.getDescription());
            testServiceDto.setPrice(s.getPrice());
            testServiceDto.setDuration(s.getDuration());
            return testServiceDto;
        });

        // Act
        ServiceDto result = serviceService.updateService(serviceId, updatedDto);

        // Assert
        assertNotNull(result);
        assertEquals(updatedDto.getName(), result.getName());
        assertEquals(updatedDto.getDescription(), result.getDescription());
        assertEquals(0, updatedDto.getPrice().compareTo(result.getPrice()));
        assertEquals(updatedDto.getDuration(), result.getDuration());
        verify(serviceRepository, times(1)).findById(serviceId);
        verify(serviceRepository, times(1)).save(any(Service.class));
    }

    @Test
    void deleteService_ShouldDeleteService() {
        // Arrange
        when(serviceRepository.existsById(serviceId)).thenReturn(true);
        doNothing().when(serviceRepository).deleteById(serviceId);

        // Act
        serviceService.deleteService(serviceId);

        // Assert
        verify(serviceRepository, times(1)).deleteById(serviceId);
    }

    @Test
    void deleteService_ShouldThrowException_WhenServiceNotFound() {
        // Arrange
        when(serviceRepository.existsById(serviceId)).thenReturn(false);

        // Act & Assert
        assertThrows(ResourceNotFoundException.class, () -> {
            serviceService.deleteService(serviceId);
        });
        verify(serviceRepository, never()).deleteById(anyLong());
    }
}
