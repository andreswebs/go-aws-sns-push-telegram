package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Payload struct {
	ChatID string `json:"chat_id"`
	Text   string `json:"text"`
}

var token string
var chatID string
var apiURL string
var endpoint string

func init() {
	token = os.Getenv("TELEGRAM_BOT_TOKEN")
	if token == "" {
		log.Fatal("missing environment variable TELEGRAM_BOT_TOKEN")
	}

	chatID = os.Getenv("TELEGRAM_CHAT_ID")
	if chatID == "" {
		log.Fatal("missing environment variable TELEGRAM_CHAT_ID")
	}

	apiURL = os.Getenv("TELEGRAM_API_URL")
	if apiURL == "" {
		apiURL = "https://api.telegram.org"
	}

	endpoint = fmt.Sprintf("%s/bot%s/sendMessage", apiURL, token)
}

func handler(ctx context.Context, snsEvent events.SNSEvent) {
	for _, r := range snsEvent.Records {
		snsRecord := r.SNS
		fmt.Printf("[%s %s] Message: %s\n", r.EventSource, snsRecord.Timestamp, snsRecord.Message)

		msg, err := json.Marshal(snsRecord)
		if err != nil {
			log.Fatal(fmt.Errorf("failed to marshal JSON: %v", err))
		}

		err = sendMsg(endpoint, string(msg))
		if err != nil {
			log.Fatal(err)
		}
	}

}

func main() {
	lambda.Start(handler)
}

func sendMsg(url, msg string) error {
	payload := Payload{
		ChatID: chatID,
		Text:   msg,
	}

	jsonPayload, err := json.Marshal(payload)
	if err != nil {
		return fmt.Errorf("failed to marshal JSON: %v", err)
	}

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonPayload))
	if err != nil {
		return err
	}

	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	res, err := client.Do(req)
	if err != nil {
		return err
	}
	defer res.Body.Close()

	if res.StatusCode != http.StatusOK {
		return fmt.Errorf("error: %d", res.StatusCode)
	}

	return nil
}
