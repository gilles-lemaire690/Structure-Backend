package com.NND.tech.Structure_Backend.Service;

import com.NND.tech.Structure_Backend.DTO.ServiceProduitRequest;
import com.NND.tech.Structure_Backend.repository.ServiceRepository;
import com.NND.tech.Structure_Backend.repository.UserRepository;
import com.NND.tech.Structure_Backend.model.entity.ServiceEntity;
import com.NND.tech.Structure_Backend.model.entity.Structure;
import com.NND.tech.Structure_Backend.model.entity.User;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
public class ServiceProduitService {

    private final ServiceRepository serviceRepository;
    private final UserRepository userRepository;

    public ServiceProduitService(ServiceRepository serviceRepository, UserRepository userRepository) {
        this.serviceRepository = serviceRepository;
        this.userRepository = userRepository;
    }

    public ServiceEntity createServiceProduit(ServiceProduitRequest request, String adminEmail) {
        User admin = userRepository.findByEmail(adminEmail)
                .orElseThrow(() -> new UsernameNotFoundException("Admin non trouvé: " + adminEmail));

        Structure structure = admin.getStructure();
        if (structure == null) {
            throw new IllegalStateException("Cet admin n'est associé à aucune structure.");
        }

        ServiceEntity service = ServiceEntity.builder()
                .name(request.getNom())
                .description(request.getDescription())
                .price(new BigDecimal(request.getPrix()))
                .structure(structure)
                .category("default") // À mettre à jour selon la logique métier
                .duration(0) // Valeur par défaut, à mettre à jour selon la logique métier
                .active(true)
                .build();

        return serviceRepository.save(service);
    }

    public ServiceEntity updateServiceProduit(Long serviceId, ServiceProduitRequest request, String adminEmail) {
        ServiceEntity service = serviceRepository.findById(serviceId)
                .orElseThrow(() -> new IllegalArgumentException("Service/Produit non trouvé avec l'id: " + serviceId));

        checkOwnership(service, adminEmail);

        service.setName(request.getNom());
        service.setDescription(request.getDescription());
        service.setPrice(new BigDecimal(request.getPrix()));
        // Mettre à jour d'autres champs si nécessaire

        return serviceRepository.save(service);
    }

    public void deleteServiceProduit(Long serviceId, String adminEmail) {
        ServiceEntity service = serviceRepository.findById(serviceId)
                .orElseThrow(() -> new IllegalArgumentException("Service/Produit non trouvé avec l'id: " + serviceId));

        checkOwnership(service, adminEmail);

        serviceRepository.delete(service);
    }

    private void checkOwnership(ServiceEntity service, String adminEmail) {
        User admin = userRepository.findByEmail(adminEmail)
                .orElseThrow(() -> new UsernameNotFoundException("Admin non trouvé: " + adminEmail));

        Structure structure = admin.getStructure();
        if (structure == null || !service.getStructure().getId().equals(structure.getId())) {
            throw new IllegalArgumentException("L'utilisateur n'est pas autorisé à modifier ce service/produit.");
        }
    }
}