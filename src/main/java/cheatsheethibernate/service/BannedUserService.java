package cheatsheethibernate.service;

import java.time.LocalDateTime;
import java.util.List;
import cheatsheethibernate.entity.BannedUser;

public interface BannedUserService {

    /**
     * Ban a user with duration in days
     * 
     * @param userId       User to ban
     * @param adminId      Admin who performed the ban
     * @param reason       Reason for ban
     * @param durationDays Duration in days (null for permanent)
     */
    void banUser(Integer userId, Integer adminId, String reason, Integer durationDays);

    /**
     * Ban a user with string duration and expiry date
     * 
     * @param userId       User to ban
     * @param adminId      Admin who performed the ban
     * @param reason       Reason for ban
     * @param banDuration  Duration string (e.g., "3 Days", "7 Days", "Permanent")
     * @param expiresAt    Expiry date (null for permanent)
     */
    void banUser(Integer userId, Integer adminId, String reason, String banDuration, LocalDateTime expiresAt);

    /**
     * Check if a user is currently banned
     * 
     * @param userId User ID to check
     * @return true if user is banned, false otherwise
     */
    boolean isUserBanned(Integer userId);

    /**
     * Get all active bans
     * 
     * @return List of active BannedUser records
     */
    List<BannedUser> getAllActiveBans();

    /**
     * Get expired bans
     * 
     * @return List of expired BannedUser records
     */
    List<BannedUser> getExpiredBans();

    /**
     * Unban a user (soft delete)
     * 
     * @param userId User ID to unban
     */
    void unbanUser(Integer userId);
}