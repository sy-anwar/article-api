package middlewares

import (
	"errors"
	"net/http"

	"github.com/sy-anwar/article-api/auth"
	"github.com/sy-anwar/article-api/responses"
)

// SetMiddlewareJSON func
func SetMiddlewareJSON(next http.HandlerFunc) http.HandlerFunc {
	return func(writer http.ResponseWriter, req *http.Request) {
		writer.Header().Set("Content-Type", "application/json")
		next(writer, req)
	}
}

// SetMiddlewareAuth func
func SetMiddlewareAuth(next http.HandlerFunc) http.HandlerFunc {
	return func(writer http.ResponseWriter, req *http.Request) {
		err := auth.TokenValid(req)
		if err != nil {
			responses.ERROR(writer, http.StatusUnauthorized, errors.New("Unauthorized"))
			return
		}
		next(writer, req)
	}
}