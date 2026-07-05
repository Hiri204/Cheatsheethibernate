package cheatsheethibernate.repository;

import cheatsheethibernate.entity.User;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface UserRepository {

    // ===== Basic CRUD Operations =====
    
    /**
     * Get all users
     * @return List of all users
     */
    List<User> getAllUsers();

    /**
     * Save a new user
     * @param user The user to save
     */
    void saveUser(User user);

    /**
     * Get user by ID
     * @param id The user ID
     * @return The user, or null if not found
     */
    User getById(Integer id);

    /**
     * Get user by ID using Optional
     * @param id The user ID
     * @return Optional containing the user if found
     */
    Optional<User> findByIdOptional(Integer id);

    /**
     * Update an existing user
     * @param user The user with updated values
     */
    void updateUser(User user);

    /**
     * Delete a user by ID (Hard Delete)
     * @param id The user ID to delete
     */
    void deleteUser(Integer id);

    /**
     * Soft delete a user by ID (Set deletedAt timestamp)
     * @param id The user ID to soft delete
     */
    void softDeleteUser(Integer id);

    /**
     * Check if a user exists
     * @param id The user ID
     * @return true if exists, false otherwise
     */
    boolean exists(Integer id);

    /**
     * Get total number of users
     * @return Total user count
     */
    long count();

    // ===== Search and Find Methods =====
    
    /**
     * Find user by username
     * @param username The username
     * @return The user, or null if not found
     */
    User findByUsername(String username);

    /**
     * Find user by email
     * @param email The email
     * @return The user, or null if not found
     */
    User findByEmail(String email);

    /**
     * Search users by keyword (username, email, or name)
     * @param keyword The search keyword
     * @return List of matching users
     */
    List<User> searchUsers(String keyword);

    /**
     * Find users by status
     * @param status The status to filter by
     * @return List of users with the given status
     */
    List<User> findUsersByStatus(String status);

    /**
     * Count users by status
     * @param status The status to count
     * @return Number of users with the given status
     */
    long countByStatus(String status);

    /**
     * Find users by role
     * @param role The role to filter by
     * @return List of users with the given role
     */
    List<User> findUsersByRole(String role);

    /**
     * Get recent users
     * @param limit Maximum number of users to return
     * @return List of recent users
     */
    List<User> getRecentUsers(int limit);

    // ===== Password Reset Methods =====
    
    /**
     * Clear expired password reset codes
     * @return Number of reset codes cleared
     */
    int clearExpiredResetCodes();

    /**
     * Save reset code for a user
     * @param email The user's email
     * @param resetCode The reset code
     * @param expiryDate The expiry date
     */
    void saveResetCode(String email, String resetCode, LocalDateTime expiryDate);

    /**
     * Find user by reset code
     * @param resetCode The reset code
     * @return The user, or null if not found
     */
    User findByResetCode(String resetCode);

    // ===== User Status Management =====
    
    /**
     * Suspend a user account
     * @param userId The user ID
     * @param reason The reason for suspension
     */
    void suspendUser(Integer userId, String reason);

    /**
     * Unsuspend a user account
     * @param userId The user ID
     */
    void unsuspendUser(Integer userId);

    /**
     * Get all suspended users
     * @return List of suspended users
     */
    List<User> getSuspendedUsers();

    // ===== Follow/Unfollow Methods =====
    
    /**
     * Follow a user
     * @param followerId The ID of the follower
     * @param followingId The ID of the user to follow
     */
    void follow(Long followerId, Long followingId);

    /**
     * Unfollow a user
     * @param followerId The ID of the follower
     * @param followingId The ID of the user to unfollow
     */
    void unfollow(Long followerId, Long followingId);

    /**
     * Check if a user is following another user
     * @param followerId The ID of the follower
     * @param followingId The ID of the user being followed
     * @return true if following, false otherwise
     */
    boolean isFollowing(Long followerId, Long followingId);

    /**
     * Count followers for a user
     * @param userId The user ID
     * @return Number of followers
     */
    long countFollowers(Long userId);

    /**
     * Count following for a user
     * @param userId The user ID
     * @return Number of users this user is following
     */
    long countFollowing(Long userId);

    /**
     * Get list of followers for a user
     * @param userId The user ID
     * @return List of users following this user
     */
    List<User> getFollowers(Long userId);

    /**
     * Get list of users this user is following
     * @param userId The user ID
     * @return List of users this user follows
     */
    List<User> getFollowing(Long userId);

    /**
     * Check if a user has any followers
     * @param userId The user ID
     * @return true if has followers, false otherwise
     */
    boolean hasFollowers(Long userId);

    /**
     * Check if a user is following anyone
     * @param userId The user ID
     * @return true if following anyone, false otherwise
     */
    boolean hasFollowing(Long userId);

    // ===== Statistics Methods =====
    
    /**
     * Get user registration statistics by date range
     * @param startDate The start date
     * @param endDate The end date
     * @return List of Object arrays [registrationDate, count]
     */
    List<Object[]> getUserRegistrationStats(LocalDateTime startDate, LocalDateTime endDate);

    /**
     * Get user role distribution
     * @return List of Object arrays [role, count]
     */
    List<Object[]> getUserRoleDistribution();

    /**
     * Count users registered between two dates
     * @param monthStart The start date
     * @param monthEnd The end date
     * @return Number of users
     */
    long countUsersBetween(LocalDateTime monthStart, LocalDateTime monthEnd);

    /**
     * Count new users since a given date
     * @param since The date to count from
     * @return Number of new users
     */
    long countNewUsersSince(LocalDateTime since);

    // ===== Bulk Operations =====
    
    /**
     * Bulk update user status
     * @param userIds List of user IDs
     * @param status The new status
     * @return Number of users updated
     */
    int bulkUpdateStatus(List<Integer> userIds, String status);

    /**
     * Delete inactive users
     * @param cutoffDate The cutoff date for inactivity
     * @return Number of users deleted
     */
    int deleteInactiveUsers(LocalDateTime cutoffDate);

    // ===== Validation Methods =====
    
    /**
     * Check if username is taken
     * @param username The username to check
     * @return true if taken, false otherwise
     */
    boolean isUsernameTaken(String username);

    /**
     * Check if email is taken
     * @param email The email to check
     * @return true if taken, false otherwise
     */
    boolean isEmailTaken(String email);

    /**
     * Check if phone number is taken
     * @param phone The phone number to check
     * @return true if taken, false otherwise
     */
    boolean isPhoneTaken(String phone);
}