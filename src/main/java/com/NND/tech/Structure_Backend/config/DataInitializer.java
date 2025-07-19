package com.NND.tech.Structure_Backend.config;

import com.NND.tech.Structure_Backend.Repository.UtilisateurRepository;
import com.NND.tech.Structure_Backend.entities.RoleType;
import com.NND.tech.Structure_Backend.entities.Utilisateur;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class DataInitializer implements CommandLineRunner {

    private final UtilisateurRepository utilisateurRepository;
    private final PasswordEncoder passwordEncoder;

    @Value("${app.superadmin.email}")
    private String superAdminEmail;

    @Value("${app.superadmin.password}")
    private String superAdminPassword;

    public DataInitializer(UtilisateurRepository utilisateurRepository, PasswordEncoder passwordEncoder) {
        this.utilisateurRepository = utilisateurRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        // 🔍 Vérifie les utilisateurs avec un rôle mal formé
        utilisateurRepository.findAll().forEach(utilisateur -> {
            try {
                RoleType correctedRole = RoleType.valueOf(utilisateur.getRole().name().toUpperCase());
                utilisateur.setRole(correctedRole);
            } catch (IllegalArgumentException | NullPointerException e) {
                System.err.println("Rôle invalide détecté pour l'utilisateur : " + utilisateur.getEmail());
                utilisateur.setRole(RoleType.CLIENT); // rôle par défaut ou à définir selon ton projet
            }
        });

        // 🔄 Sauvegarde les modifications
        utilisateurRepository.flush(); // ou saveAll si tu préfères

        // 👤 Création du SUPER_ADMIN si absent
        Optional<Utilisateur> existingSuperAdmin = utilisateurRepository.findByEmail(superAdminEmail);

        if (existingSuperAdmin.isEmpty()) {
            Utilisateur superAdmin = new Utilisateur(
                    "SUPER",
                    "ADMIN",
                    "690145368",
                    superAdminEmail,
                    passwordEncoder.encode(superAdminPassword),
                    RoleType.SUPER_ADMIN
            );
            utilisateurRepository.save(superAdmin);
            System.out.println("✅ Super administrateur créé automatiquement.");
        } else {
            System.out.println("ℹ️ Super administrateur déjà existant.");
        }

        utilisateurRepository.findAll().forEach(user -> {
            try {
                RoleType corrected = RoleType.valueOf(user.getRole().name().toUpperCase());
                user.setRole(corrected);
            } catch (Exception e) {
                user.setRole(RoleType.CLIENT); // Ou autre rôle par défaut
            }
        });
        utilisateurRepository.flush();

    }
}
