package responses

import (
	"encoding/json"
	"fmt"
	"net/http"
)

func JSON(writer http.ResponseWriter, status int, data interface{}) {
	writer.WriteHeader(status)
	err := json.NewEncoder(writer).Encode(data)
	if err != nil {
		fmt.Fprintf(writer, "%s", err.Error())
	}
}

func ERROR(writer http.ResponseWriter, status int, err error) {
	if err != nil {
		JSON(writer, status, struct {
			Error string `json:"error"`
		}{
			Error: err.Error(),
		}
		})
		return
	}
	JSON(writer, http.StatusBadRequest, nil)
}