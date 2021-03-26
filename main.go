package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/GuilhermeCaruso/bellt"
)

var APP_PORT string = "8080"
var APP_LISTEN string = fmt.Sprintf("0.0.0.0:%s", APP_PORT)

func init() {
	log.Println("Booting hostwithquantum/example-go-app")
	log.Printf("Listening on: %s\n", APP_LISTEN)
	log.Printf("Run `curl http://127.0.0.0:%s/hello` to test", APP_PORT)
}

func main() {
	router := bellt.NewRouter()

	router.HandleFunc("/about", aboutHandler, "GET")
	router.HandleFunc("/hello", helloHandler, "GET")

	log.Fatal(http.ListenAndServe(APP_LISTEN, nil))
}

func aboutHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("This is an <a href=\"https://github.com/hostwithquantum/example-go-app\">example-go-app</a> for Planetary Quantum."))
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	log.Printf("Request to %s from %s: ", r.URL.Path, r.RemoteAddr)

	w.WriteHeader(http.StatusOK)
	w.Write([]byte(os.Getenv("HELLO_RESPONSE")))
}
