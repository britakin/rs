package main

import (
	"fmt"
	"log"
	"net/http"
)

func main()  {
	log.Print("sss")

	port := "8182"

	s := http.Server{
		Addr: ":" + port,
		Handler: nil,
	}

	http.HandleFunc("/", handler)

	err := s.ListenAndServe()
	if err != nil {
		log.Fatal("Blahhh: :v", err)
	}
}

func handler(w http.ResponseWriter, r *http.Request)  {
	fmt.Fprint(w, http.StatusText(http.StatusOK))
}
