package cheatsheethibernate.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "bookmarks")
public class Bookmark {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name = "user_id", nullable = false)
	private Integer userId;

	@Column(name = "sheet_id", nullable = false)
	private Long sheetId;

	@Column(name = "created_at")
	private Date createdAt;

	// Transient fields (not stored in DB)
	private transient String sheetTitle;
	private transient String sheetCategory;
	private transient String sheetAuthor;
	private transient Integer likeCount;

	// Getters and Setters
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public Long getSheetId() {
		return sheetId;
	}

	public void setSheetId(Long sheetId) {
		this.sheetId = sheetId;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public String getSheetTitle() {
		return sheetTitle;
	}

	public void setSheetTitle(String sheetTitle) {
		this.sheetTitle = sheetTitle;
	}

	public String getSheetCategory() {
		return sheetCategory;
	}

	public void setSheetCategory(String sheetCategory) {
		this.sheetCategory = sheetCategory;
	}

	public String getSheetAuthor() {
		return sheetAuthor;
	}

	public void setSheetAuthor(String sheetAuthor) {
		this.sheetAuthor = sheetAuthor;
	}

	public Integer getLikeCount() {
		return likeCount;
	}

	public void setLikeCount(Integer likeCount) {
		this.likeCount = likeCount;
	}
}