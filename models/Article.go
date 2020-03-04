package models

import (
	"errors"
	"html"
	"strings"
	"time"

	"github.com/jinzhu/gorm"
)

// Article struct
type Article struct { 
	ArticleID uint32    `gorm:"primary_key;auto_increment" json:"article_id"`
	Title     string    `gorm:"size:255;not null;unique" json:"title"`
	Content   string    `gorm:"not null;" json:"content"`
	Author    User      `json:"author"`
	AuthorID  uint32    `gorm:"not null" json:"author_id"`
	Tags	  string    `gorm:"size:255;" json:"tags"`
	CreatedAt time.Time `gorm:"default:CURRENT_TIMESTAMP" json:"created_at"`
	UpdatedAt time.Time `gorm:"default:CURRENT_TIMESTAMP" json:"updated_at"`
}

// Prepare method
func (ar *Article) Prepare() {
	ar.ArticleID = 0
	ar.Title = html.EscapeString(strings.TrimSpace(ar.Title))
	ar.Content = html.EscapeString(strings.TrimSpace(ar.Content))
	ar.Author = User{}
	ar.CreatedAt = time.Now()
	ar.UpdatedAt = time.Now()
}

// Validate method
func (ar *Article) ValidateArticle() error {
	if ar.Title == "" {
		return errors.New("Required Title")
	}
	if ar.Content == "" {
		return errors.New("Required Content")
	}
	if ar.AuthorID < 1 {
		return errors.New("Required Author")
	}
	return nil
}

// SavePost method
func (ar *Article) SaveArticle(db *gorm.DB) (*Article, error) {
	var err error
	err = db.Debug().
		Model(&Article{}).
		Create(&ar).
		Error
	if err != nil {
		return &Article{}, err
	}
	if ar.ID != 0 {
		err = db.Debug().
			Model(&User{}).
			Where("user_id = ?", ar.AuthorID).
			Take(&ar.Author).
			Error
		if err != nil {
			return &Article{}, err
		}
	}
	return ar, nil
}

// FindAllPosts method
func (ar *Article) GetAllArticles(db *gorm.DB) (*[]Article, error) {
	var err error
	articles := []Article{}
	err = db.Debug().
		Model(&Article{}).
		Limit(100).
		Find(&articles).
		Error
	if err != nil {
		return &[]Article{}, err
	}
	if len(articles) > 0 {
		for i, := range articles {
			err := db.Debug().
				Model(&User{}).
				Where("user_id = ?", articles[i].AuthorID).
				Take(&articles[i].Author).
				Error
			if err != nil {
				return &[]Article{}, err
			}
		}
	}
	return &articles, nil
}

// FindPostByID method
func (ar *Article) GetArticleByID(db *gorm.DB, article_id uint32) (*Article, error) {
	var err error
	err = db.Debug().
		Model(&Article{}).
		Where("article_id = ?", article_id).
		Take(&ar).
		Error
	if err != nil {
		return &Article{}, err
	}
	if ar.ID != 0 {
		err = db.Debug().
			Model(&User{}).
			Where("id = ?", ar.AuthorID).
			Take(&ar.Author).
			Error
		if err != nil {
			return &Article{}, err
		}
	}
	return ar, nil
}

// UpdateAPost method 
func (ar *Article) UpdateArticle(db *gorm.DB) (*Article, error) {
	var err error
	err = db.Debug().
		Model(&Article{}).
		Where("article_id = ?", ar.ArticleID).
		Updates(Article{Title: ar.Title, Content: ar.Content, UpdatedAt: time.Now()}).
		Error
	if err != nil {
		return &Article{}, err
	}
	if ar.ArticleID != 0 {
		err = db.Debug().
			Model(&User{}).
			Where("user_id = ?", ar.AuthorID).
			Take(&ar.Author).
			Error
		if err != nil {
			return &Article{}, err
		}
	}
	return ar, nil
}

// DeleteAPost method
func (ar *Article) DeleteArticleByID(db *gorm.DB, article_id uint32, user_id uint32) (int64, error) {
	db = db.Debug().
		Model(&Article{}).
		Where("article_id = ? and author_id = ?", article_id, user_id).
		Take(&Article{}).
		Delete(&Article{})

	if db.Error != nil {
		if gorm.IsRecordNotFoundError(db.Error) {
			return 0, errors.New("Article not found")
		}
		return 0, db.Error
	}
	return db.RowsAffected, nil
}