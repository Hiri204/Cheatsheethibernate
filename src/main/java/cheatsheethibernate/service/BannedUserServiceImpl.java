package cheatsheethibernate.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cheatsheethibernate.entity.BannedUser;
import cheatsheethibernate.entity.User;
import cheatsheethibernate.repository.BannedUserRepository;
import cheatsheethibernate.repository.UserRepository;
import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
public class BannedUserServiceImpl implements BannedUserService {

    @Autowired
    private BannedUserRepository bannedUserRepository;

    @Autowired
    private UserRepository userRepository;

    // ===== 1. Ban User with duration in days =====
    @Override
    public void banUser(Integer userId, Integer adminId, String reason, Integer durationDays) {
        User user = userRepository.getById(userId);
        if (user != null) {
            BannedUser bannedUser = new BannedUser();
            bannedUser.setUser(user);
            bannedUser.setBannedBy(Long.valueOf(adminId));
            bannedUser.setReason(reason);
            bannedUser.setBannedAt(LocalDateTime.now());

            if (durationDays != null && durationDays > 0) {
                bannedUser.setExpiresAt(LocalDateTime.now().plusDays(durationDays));
            } else {
                bannedUser.setExpiresAt(null); // Permanent ban
            }
            bannedUserRepository.save(bannedUser);
        }
    }

    // ===== 2. Ban User with string duration and expiry date =====
    @Override
    public void banUser(Integer userId, Integer adminId, String reason, String banDuration, LocalDateTime expiresAt) {
        User user = userRepository.getById(userId);
        if (user != null) {
            BannedUser bannedUser = new BannedUser();
            bannedUser.setUser(user);
            bannedUser.setBannedBy(Long.valueOf(adminId));
            
            // Add duration info to reason if needed
            String fullReason = reason;
            if (banDuration != null && !banDuration.isEmpty()) {
                fullReason = reason + " (Duration: " + banDuration + ")";
            }
            bannedUser.setReason(fullReason);
            
            bannedUser.setBannedAt(LocalDateTime.now());
            bannedUser.setExpiresAt(expiresAt); // Use expiry date from controller
            
            bannedUserRepository.save(bannedUser);
        }
    }

    // ===== 3. Check if user is banned =====
    @Override
    @Transactional(readOnly = true)
    public boolean isUserBanned(Integer userId) {
        BannedUser activeBan = bannedUserRepository.findActiveBanByUserId(userId);
        return activeBan != null;
    }

    // ===== 4. Get all active bans =====
    @Override
    @Transactional(readOnly = true)
    public List<BannedUser> getAllActiveBans() {
        return bannedUserRepository.findAllActiveBans();
    }

    // ===== 5. Get expired bans =====
    @Override
    @Transactional(readOnly = true)
    public List<BannedUser> getExpiredBans() {
        return bannedUserRepository.findExpiredBans();
    }

    // ===== 6. Unban a user =====
    @Override
    @Transactional
    public void unbanUser(Integer userId) {
        // Find active ban
        BannedUser activeBan = bannedUserRepository.findActiveBanByUserId(userId);
        if (activeBan != null) {
            // Soft delete by setting expiresAt to now (so it won't appear in active bans)
            activeBan.setExpiresAt(LocalDateTime.now());
            bannedUserRepository.save(activeBan);
        }
    }
}