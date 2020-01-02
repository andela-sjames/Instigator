package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/mux"
	"github.com/segmentio/kafka-go"
)

// HomeHandler defined
// return a simple welcome text
func HomeHandler(w http.ResponseWriter, r *http.Request) {
	json.NewEncoder(w).Encode(map[string]string{
		"status":  "200",
		"message": "Welcome to Consumer API",
	})
}

// StartConsumerHandler defined
func StartConsumerHandler(w http.ResponseWriter, r *http.Request) {
	// to consume messages
	// make a new reader that consumes from topic-A
	fmt.Println("Consumer started")
	go func() {
		reader := kafka.NewReader(kafka.ReaderConfig{
			Brokers:        []string{"broker:9092", "broker:9093", "broker:9093"},
			GroupID:        "consumer-Sample-One",
			Topic:          "sampleOne",
			MinBytes:       10e3,        // 10KB
			MaxBytes:       10e6,        // 10MB
			CommitInterval: time.Second, // flushes commits to Kafka every second
		})

		for {
			m, err := reader.ReadMessage(context.Background())
			if err != nil {
				break
			}
			fmt.Printf("message at topic/partition/offset %v/%v/%v: %s = %s\n", m.Topic, m.Partition, m.Offset, string(m.Key), string(m.Value))
		}
		reader.Close()
	}()

	w.Header().Add("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{
		"status":  "200",
		"message": "Consumer started",
	})
}

// EndConsumerHandler route defined
func EndConsumerHandler(w http.ResponseWriter, r *http.Request) {
	json.NewEncoder(w).Encode(map[string]string{
		"status":  "200",
		"message": "Welcome to Consumer API",
	})
}

func main() {
	fmt.Println("Consumer started")

	router := mux.NewRouter()

	// Home route
	router.HandleFunc("/", HomeHandler)

	// Start Consumer Route
	router.HandleFunc("/start_consumer", StartConsumerHandler)

	// Stop Consumer Route
	router.HandleFunc("/end_consumer", EndConsumerHandler)

	// server block defined here
	srv := &http.Server{
		Handler: router,
		Addr:    "0.0.0.0:8000",

		// Good practice: enforce timeouts for servers you create!
		WriteTimeout: 15 * time.Second,
		ReadTimeout:  15 * time.Second,
	}

	log.Println("Starting server on port :8000")
	log.Fatal(srv.ListenAndServe())

}
