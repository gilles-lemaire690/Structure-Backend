package com.NND.tech.Structure_Backend.entities;

public enum RoleType {
    ADMIN,
    SUPER_ADMIN,
    CLIENT;

    public static RoleType fromString(String value) {
        try {
            return RoleType.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Rôle invalide : " + value);
        }
    }
}
