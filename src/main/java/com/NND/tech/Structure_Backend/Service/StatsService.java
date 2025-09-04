package com.NND.tech.Structure_Backend.service;

import com.NND.tech.Structure_Backend.config.CacheConfig;
import com.NND.tech.Structure_Backend.dto.StatsDto;
import com.NND.tech.Structure_Backend.repository.StructureRepository;
import com.NND.tech.Structure_Backend.repository.TransactionRepository;
import com.NND.tech.Structure_Backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public interface StatsService {
    /**
     * Récupère les statistiques globales de l'application
     * @return DTO contenant les statistiques globales
     */
    @Cacheable(value = CacheConfig.STATS_CACHE, key = "T(com.NND.tech.Structure_Backend.config.CacheConfig).GLOBAL_STATS_KEY")
    StatsDto getGlobalStats();
    
    /**
     * Récupère les statistiques sur une plage de dates donnée
     * @param startDate Date de début de la période
     * @param endDate Date de fin de la période
     * @return DTO contenant les statistiques pour la période spécifiée
     * @throws IllegalArgumentException si la date de début est postérieure à la date de fin
     */
    @Cacheable(value = CacheConfig.STATS_CACHE, 
               key = "T(com.NND.tech.Structure_Backend.config.CacheConfig).DATE_RANGE_STATS_KEY_PREFIX + #startDate.toString() + '_' + #endDate.toString()")
    StatsDto getStatsByDateRange(LocalDate startDate, LocalDate endDate);
    
    /**
     * Récupère les statistiques pour une structure spécifique
     * @param structureId Identifiant de la structure
     * @return DTO contenant les statistiques de la structure
     * @throws IllegalArgumentException si aucune structure n'est trouvée avec l'ID fourni
     */
    @Cacheable(value = CacheConfig.STATS_CACHE, 
               key = "T(com.NND.tech.Structure_Backend.config.CacheConfig).STRUCTURE_STATS_KEY_PREFIX + #structureId")
    StatsDto getStatsByStructure(Long structureId);
    
    /**
     * Vide le cache des statistiques
     */
    @CacheEvict(value = CacheConfig.STATS_CACHE, allEntries = true)
    void clearStatsCache();
    
    /**
     * Obtient les tendances de revenus sur une période donnée
     * @param startDate Date de début
     * @param endDate Date de fin
     * @param period Période de regroupement (daily, weekly, monthly)
     * @return Map des dates/périodes avec les montants de revenus
     */
    Map<String, Double> getRevenueTrend(LocalDate startDate, LocalDate endDate, String period);
    
    /**
     * Compare les statistiques entre deux périodes
     * @param firstPeriodStart Début de la première période
     * @param firstPeriodEnd Fin de la première période
     * @param secondPeriodStart Début de la deuxième période
     * @param secondPeriodEnd Fin de la deuxième période
     * @return Map contenant les statistiques comparées et les variations
     */
    Map<String, Object> comparePeriods(
        LocalDate firstPeriodStart, LocalDate firstPeriodEnd,
        LocalDate secondPeriodStart, LocalDate secondPeriodEnd);
    
    /**
     * Obtient les structures les plus performantes par revenus
     * @param limit Nombre maximum de structures à retourner
     * @return Liste des structures avec leurs statistiques de performance
     */
    List<Map<String, Object>> getTopPerformingStructures(int limit);
    
    /**
     * Obtient la répartition des revenus par catégorie
     * @param startDate Date de début
     * @param endDate Date de fin
     * @return Map des catégories avec leurs revenus respectifs
     */
    Map<String, Double> getRevenueByCategory(LocalDate startDate, LocalDate endDate);
}

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
class StatsServiceImpl implements StatsService {

    private final TransactionRepository transactionRepository;
    private final StructureRepository structureRepository;
    private final UserRepository userRepository;

    @Override
    public StatsDto getGlobalStats() {
        long totalTransactions = transactionRepository.count();
        double totalRevenue = transactionRepository.getTotalRevenue();
        long totalStructures = structureRepository.count();
        long totalUsers = userRepository.count();
        
        return StatsDto.builder()
                .totalTransactions(totalTransactions)
                .totalRevenue(totalRevenue)
                .totalStructures(totalStructures)
                .totalUsers(totalUsers)
                .build();
    }

    @Override
    public StatsDto getStatsByDateRange(LocalDate startDate, LocalDate endDate) {
        if (startDate.isAfter(endDate)) {
            throw new IllegalArgumentException("La date de début doit être antérieure à la date de fin");
        }

        long transactionsInPeriod = transactionRepository.countByTransactionDateBetween(startDate, endDate);
        double revenueInPeriod = transactionRepository.getTotalRevenueByDateRange(startDate, endDate);
        
        return StatsDto.builder()
                .totalTransactions(transactionsInPeriod)
                .totalRevenue(revenueInPeriod)
                .build();
    }

    @Override
    public StatsDto getStatsByStructure(Long structureId) {
        if (!structureRepository.existsById(structureId)) {
            throw new IllegalArgumentException("Structure non trouvée avec l'ID : " + structureId);
        }

        long transactionsCount = transactionRepository.countByStructureId(structureId);
        double totalRevenue = transactionRepository.getTotalRevenueByStructureId(structureId);
        
        return StatsDto.builder()
                .totalTransactions(transactionsCount)
                .totalRevenue(totalRevenue)
                .build();
    }
    
    @Override
    @CacheEvict(value = CacheConfig.STATS_CACHE, allEntries = true)
    public void clearStatsCache() {
        // La logique de nettoyage du cache est gérée par l'annotation @CacheEvict
    }
    
    @Override
    public Map<String, Double> getRevenueTrend(LocalDate startDate, LocalDate endDate, String period) {
        if (startDate.isAfter(endDate)) {
            throw new IllegalArgumentException("La date de début doit être antérieure à la date de fin");
        }
        
        Map<String, Double> revenueTrend = new LinkedHashMap<>();
        LocalDate current = startDate;
        
        while (!current.isAfter(endDate)) {
            LocalDate periodEnd = period.equals("monthly") ? 
                current.withDayOfMonth(current.lengthOfMonth()) : 
                period.equals("weekly") ? 
                    current.plusDays(6) : 
                    current;
                    
            if (periodEnd.isAfter(endDate)) {
                periodEnd = endDate;
            }
            
            double revenue = transactionRepository.getTotalRevenueByDateRange(current, periodEnd);
            String periodKey = period.equals("monthly") ? 
                current.getMonth().toString() + " " + current.getYear() :
                period.equals("weekly") ? 
                    "Semaine du " + current : 
                    current.toString();
                    
            revenueTrend.put(periodKey, revenue);
            
            current = period.equals("monthly") ? 
                current.plusMonths(1).withDayOfMonth(1) :
                period.equals("weekly") ?
                    current.plusWeeks(1) :
                    current.plusDays(1);
        }
        
        return revenueTrend;
    }
    
    @Override
    public Map<String, Object> comparePeriods(LocalDate firstPeriodStart, LocalDate firstPeriodEnd,
                                            LocalDate secondPeriodStart, LocalDate secondPeriodEnd) {
        if (firstPeriodStart.isAfter(firstPeriodEnd) || secondPeriodStart.isAfter(secondPeriodEnd)) {
            throw new IllegalArgumentException("Les dates de début doivent être antérieures aux dates de fin");
        }
        
        double firstPeriodRevenue = transactionRepository.getTotalRevenueByDateRange(firstPeriodStart, firstPeriodEnd);
        double secondPeriodRevenue = transactionRepository.getTotalRevenueByDateRange(secondPeriodStart, secondPeriodEnd);
        
        long firstPeriodCount = transactionRepository.countByTransactionDateBetween(firstPeriodStart, firstPeriodEnd);
        long secondPeriodCount = transactionRepository.countByTransactionDateBetween(secondPeriodStart, secondPeriodEnd);
        
        double revenueChange = firstPeriodRevenue == 0 ? 0 : 
            ((secondPeriodRevenue - firstPeriodRevenue) / Math.abs(firstPeriodRevenue)) * 100;
            
        double countChange = firstPeriodCount == 0 ? 0 : 
            ((double)(secondPeriodCount - firstPeriodCount) / Math.abs(firstPeriodCount)) * 100;
        
        Map<String, Object> comparison = new HashMap<>();
        comparison.put("firstPeriod", Map.of(
            "startDate", firstPeriodStart,
            "endDate", firstPeriodEnd,
            "revenue", firstPeriodRevenue,
            "transactionCount", firstPeriodCount
        ));
        
        comparison.put("secondPeriod", Map.of(
            "startDate", secondPeriodStart,
            "endDate", secondPeriodEnd,
            "revenue", secondPeriodRevenue,
            "transactionCount", secondPeriodCount
        ));
        
        comparison.put("revenueChange", revenueChange);
        comparison.put("transactionCountChange", countChange);
        
        return comparison;
    }
    
    @Override
    public List<Map<String, Object>> getTopPerformingStructures(int limit) {
        return structureRepository.findAll().stream()
            .map(structure -> {
                double revenue = transactionRepository.getTotalRevenueByStructureId(structure.getId());
                long transactionCount = transactionRepository.countByStructureId(structure.getId());
                
                Map<String, Object> stats = new HashMap<>();
                stats.put("id", structure.getId());
                stats.put("name", structure.getName());
                stats.put("revenue", revenue);
                stats.put("transactionCount", transactionCount);
                
                return stats;
            })
            .sorted((s1, s2) -> Double.compare(
                (double) s2.get("revenue"), 
                (double) s1.get("revenue")
            ))
            .limit(limit)
            .collect(Collectors.toList());
    }
    
    @Override
    public Map<String, Double> getRevenueByCategory(LocalDate startDate, LocalDate endDate) {
        // Cette méthode nécessite que la table Transaction ait une relation avec Service
        // et que Service ait un champ category
        return transactionRepository.findByTransactionDateBetween(startDate, endDate).stream()
            .collect(Collectors.groupingBy(
                transaction -> transaction.getService().getCategory(),
                Collectors.summingDouble(Transaction::getAmount)
            ));
    }
}
