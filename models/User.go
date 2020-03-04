package models

import (
	"errors"
	"html"
	"log"
	"strings"
	"time"

	"github.com/badoux/checkmail"
	"github.com/jinzhu/gorm"
	"golang.org/x/crypto/bcrypt"
)

// User struct
type User struct {
	UserID 	  unint32   `gorm:"primary_key;auto_increment" json:"userid"`
	UserName  string    `gorm:"size:255;not null;unique" json:"username"`
	Email     string    `gorm:"size:100;not null;unique" json:"email"`
	Password  string    `gorm:"size:100;not null;" json:"password"`
	CreatedAt time.Time `gorm:"default:CURRENT_TIMESTAMP" json:"created_at"`
	UpdatedAt time.Time `gorm:"default:CURRENT_TIMESTAMP" json:"updated_at"`
}

// HashPassword function
func HashPassword(password string) ([]byte, error) {
	return bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
}

// VerifyPassword function
func VerifyPassword(hash, password string) error {
	return bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
}

// PasswordToHash method
func (u *User) PasswordToHash() error {
	hashPassword, err := HashPassword(u.Password)
	if err != nil {
		return err
	}
	u.Password = string(hashPassword)
	return nil
}

// Prepare method
func (u *User) Prepare() {
	u.UserID = 0
	u.UserName = html.EscapeString(strings.TrimSpace(u.Nickname))
	u.Email = html.EscapeString(strings.TrimSpace(u.Email))
	u.CreatedAt = time.Now()
	u.UpdatedAt = time.Now()
}

// ValidateUser method
func (u *User) ValidateUser() error {
	if u.UserName == "" {
		return errors.New("Required Username")
	}
	if u.Password == "" {
		return errors.New("Required Password")
	}
	if u.Email == "" {
		return errors.New("Required Email")
	}
	err := checkmail.ValidateFormat(u.Email)
	if err != nil {
		return errors.New("Invalid Email")
	}
	return nil
}

// SaveUser method
func (u *User) SaveUser(db *gorm.DB) (*User, error) {
	var err error
	err = db.Debug().Create(&u).Error
	if err != nil {
		return &User{}, err
	}
	return u, nil
}

// GetAllUsers method
func (u *User) GetAllUsers(db *gorm.DB) (*[]User, error) {
	var err error
	users := []User{}
	err = db.Debug().Model(&User{}).Limit(50).Find(&users).Error
	if err != nil {
		return &[]User{}, err
	}
	return &users, err
}

// GetUserByID method
func (u *User) GetUserByID(db *gorm.DB, userID uint32) (*User, error) {
	var err error
	err = db.Debug().
		Model(User{}).
		Where("userid = ?", userID).
		Take(&u).
		Error
	if err != nil {
		return &User{}, err
	}
	if gorm.IsRecordNotFoundError(err) {
		return &User{}, errors.New("User Not Found")
	}
	return u, err
}

// UpdateUserByID method
func (u *User) UpdateUserByID(db *gorm.DB, userID uint32) (*User, error) {
	err := u.PasswordToHash()
	if err != nil {
		log.Fatal(err)
	}
	db = db.Debug().
		Model(&User{}).
		Where("userid = ?", userID).
		Take(&User{}).
		UpdateColumns(
		map[string]interface{}{
			"password":  u.Password,
			"username":  u.UserName,
			"email":     u.Email,
			"update_at": time.Now(),
		},
	)
	if db.Error != nil {
		return &User{}, db.Error
	}
	err = db.Debug().
		Model(&User{}).
		Where("userid = ?", userID).
		Take(&u).
		Error
	if err != nil {
		return &User{}, err
	}
	return u, nil
}

// DeleteUserByID method
func (u *User) DeleteUserByID(db *gorm.DB, userID uint32) (int64, error) {
	db = db.Debug().
		Model(&User{}).
		Where("userid = ?", userID).
		Take(&User{}).
		Delete(&User{})
	if db.Error != nil {
		return 0, db.Error
	}
	return db.RowsAffected, nil
}