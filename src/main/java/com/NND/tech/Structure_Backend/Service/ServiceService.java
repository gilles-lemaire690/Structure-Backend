package com.NND.tech.Structure_Backend.service;

import com.NND.tech.Structure_Backend.dto.ServiceDto;
import com.NND.tech.Structure_Backend.exception.ResourceNotFoundException;
// Utilisation du nom complet pour éviter l'ambiguïté avec l'annotation @Service
import com.NND.tech.Structure_Backend.model.entity.Structure;
import com.NND.tech.Structure_Backend.repository.ServiceRepository;
import com.NND.tech.Structure_Backend.repository.StructureRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

public interface ServiceService {
    List<ServiceDto> findByStructureId(Long structureId);
    ServiceDto findById(Long id);
    ServiceDto create(Long structureId, ServiceDto serviceDto);
    ServiceDto update(Long id, ServiceDto serviceDto);
    void deleteById(Long id);
}

@Service
@RequiredArgsConstructor
class ServiceServiceImpl implements ServiceService {
    
    private final ServiceRepository serviceRepository;
    private final StructureRepository structureRepository;
    private final ServiceMapper serviceMapper;

    @Override
    @Transactional(readOnly = true)
    public List<ServiceDto> findByStructureId(Long structureId) {
        return serviceRepository.findByStructureIdAndActiveTrue(structureId).stream()
                .map(serviceMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public ServiceDto findById(Long id) {
        return serviceRepository.findByIdAndActiveTrue(id)
                .map(serviceMapper::toDto)
                .orElseThrow(() -> new ResourceNotFoundException("Service non trouvé avec l'id : " + id));
    }

    @Override
    @Transactional
    public ServiceDto create(Long structureId, ServiceDto serviceDto) {
        Structure structure = structureRepository.findByIdAndActiveTrue(structureId)
                .orElseThrow(() -> new ResourceNotFoundException("Structure non trouvée avec l'id : " + structureId));
        
        if (serviceRepository.existsByNameAndStructureId(serviceDto.getName(), structureId)) {
            throw new IllegalArgumentException("Un service avec ce nom existe déjà pour cette structure");
        }
        
        Service service = serviceMapper.toEntity(serviceDto);
        service.setStructure(structure);
        service.setActive(true);
        
        Service savedService = serviceRepository.save(service);
        return serviceMapper.toDto(savedService);
    }

    @Override
    @Transactional
    public ServiceDto update(Long id, ServiceDto serviceDto) {
        Service existingService = serviceRepository.findByIdAndActiveTrue(id)
                .orElseThrow(() -> new ResourceNotFoundException("Service non trouvé avec l'id : " + id));
        
        // Vérification du nom unique si modifié
        if (!existingService.getName().equals(serviceDto.getName()) && 
            serviceRepository.existsByNameAndStructureId(serviceDto.getName(), existingService.getStructure().getId())) {
            throw new IllegalArgumentException("Un autre service avec ce nom existe déjà pour cette structure");
        }
        
        serviceMapper.updateFromDto(serviceDto, existingService);
        Service updatedService = serviceRepository.save(existingService);
        return serviceMapper.toDto(updatedService);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Service service = serviceRepository.findByIdAndActiveTrue(id)
                .orElseThrow(() -> new ResourceNotFoundException("Service non trouvé avec l'id : " + id));
        
        // Soft delete
        service.setActive(false);
        serviceRepository.save(service);
    }
}
