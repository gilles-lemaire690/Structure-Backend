package com.NND.tech.Structure_Backend.service;

import com.NND.tech.Structure_Backend.dto.StructureDto;
import com.NND.tech.Structure_Backend.dto.request.RegisterAdminRequest;
import com.NND.tech.Structure_Backend.dto.request.StructureRequest;
import com.NND.tech.Structure_Backend.exception.ResourceNotFoundException;
import com.NND.tech.Structure_Backend.mapper.StructureMapper;
import com.NND.tech.Structure_Backend.model.entity.Structure;
import com.NND.tech.Structure_Backend.model.entity.Utilisateur;
import com.NND.tech.Structure_Backend.model.enums.RoleType;
import com.NND.tech.Structure_Backend.repository.StructureRepository;
import com.NND.tech.Structure_Backend.repository.UtilisateurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StructureService {

    private final StructureRepository structureRepository;
    private final UtilisateurRepository utilisateurRepository;
    private final StructureMapper structureMapper;
    private final PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public List<StructureDto> findAll() {
        return structureRepository.findByActiveTrue().stream()
                .map(structureMapper::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public StructureDto findById(Long id) {
        return structureRepository.findByIdAndActiveTrue(id)
                .map(structureMapper::toDto)
                .orElseThrow(() -> new ResourceNotFoundException("Structure non trouvée avec l'id : " + id));
    }

    @Transactional
    public StructureDto create(StructureRequest request) {
        if (structureRepository.existsByName(request.getNom())) {
            throw new IllegalArgumentException("Une structure avec ce nom existe déjà");
        }
        
        Structure structure = new Structure();
        structure.setNom(request.getNom());
        structure.setDescription(request.getDescription());
        structure.setAdresse(request.getAdresse());
        structure.setLogoUrl(request.getLogoUrl());
        structure.setServicesProduits(new ArrayList<>()); // éviter null
        structure.setActive(true);

        // Création de l'admin
        Utilisateur admin = new Utilisateur();
        admin.setNom(request.getNom());
        admin.setPrenom(request.getPrenom());
        admin.setEmail(request.getEmail());
        admin.setTelephone(request.getTelephone());
        admin.setMotDePasse(passwordEncoder.encode(request.getPassword()));
        admin.setRole(RoleType.ADMIN);

        Utilisateur savedAdmin = utilisateurRepository.save(admin);
        structure.setAdmin(savedAdmin);
        Structure savedStructure = structureRepository.save(structure);

        return structureMapper.toDto(savedStructure);
    }

    @Transactional
    public StructureDto update(Long id, StructureDto structureDto) {
        Structure existingStructure = structureRepository.findByIdAndActiveTrue(id)
                .orElseThrow(() -> new ResourceNotFoundException("Structure non trouvée avec l'id : " + id));
        
        // Vérification du nom unique si modifié
        if (!existingStructure.getNom().equals(structureDto.getName()) && 
            structureRepository.existsByName(structureDto.getName())) {
            throw new IllegalArgumentException("Une autre structure avec ce nom existe déjà");
        }
        
        structureMapper.updateFromDto(structureDto, existingStructure);
        Structure updatedStructure = structureRepository.save(existingStructure);
        return structureMapper.toDto(updatedStructure);
    }

    @Transactional
    public void delete(Long id) {
        Structure structure = structureRepository.findByIdAndActiveTrue(id)
                .orElseThrow(() -> new ResourceNotFoundException("Structure non trouvée avec l'id : " + id));
        
        // Soft delete
        structure.setActive(false);
        structureRepository.save(structure);
    }

    @Transactional
    public Utilisateur createAdminForStructure(Long structureId, RegisterAdminRequest request) {
        Structure structure = structureRepository.findByIdAndActiveTrue(structureId)
                .orElseThrow(() -> new ResourceNotFoundException("Structure non trouvée avec l'id : " + structureId));

        if (structure.getAdmin() != null) {
            throw new IllegalStateException("Cette structure a déjà un administrateur.");
        }

        Utilisateur admin = new Utilisateur();
        admin.setNom(request.getNom());
        admin.setPrenom(request.getPrenom());
        admin.setEmail(request.getEmail());
        admin.setTelephone(request.getTelephone());
        admin.setMotDePasse(passwordEncoder.encode(request.getPassword()));
        admin.setRole(RoleType.ADMIN);

        Utilisateur savedAdmin = utilisateurRepository.save(admin);


        structure.setAdmin(savedAdmin);
        structureRepository.save(structure);

        return savedAdmin;
    }
}