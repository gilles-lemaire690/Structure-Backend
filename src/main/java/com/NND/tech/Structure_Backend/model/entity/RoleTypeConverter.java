package com.NND.tech.Structure_Backend.model.entity;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class RoleTypeConverter implements AttributeConverter<RoleType, String> {
    @Override
    public String convertToDatabaseColumn(RoleType attribute) {
        return attribute == null ? null : attribute.name().toLowerCase();
    }

    @Override
    public RoleType convertToEntityAttribute(String dbData) {
        return dbData == null ? null : RoleType.fromString(dbData);
    }
}
